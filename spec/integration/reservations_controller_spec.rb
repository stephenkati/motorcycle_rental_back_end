require 'swagger_helper'
# rubocop:disable Metrics/BlockLength
describe 'Reservations API' do
  let(:user) { create(:user) }

  path '/api/v1/reservations' do
    get 'List reservations for current user' do
      tags 'Reservations'
      security [bearerAuth: []]

      response '200', 'Reservations fetched successfully' do
        before do
          create_list(:reservation, 3, user:)
          get '/api/v1/reservations', headers: auth_headers(user)
        end

        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       reserve_date: { type: :string, format: :date },
                       city: { type: :string },
                       motorcycle_id: { type: :integer }
                     },
                     required: %w[id reserve_date city motorcycle_id]
                   }
                 }
               },
               required: %w[status message data]

        run_test!
      end

      response '401', 'Unauthorized' do
        before { get '/api/v1/reservations' }

        examples 'application/json' => {
          status: 'Error',
          message: 'Unauthorized'
        }
      end
    end

    post 'Create a new reservation' do
      tags 'Reservations'
      security [bearerAuth: []]

      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          reserve_date: { type: :string, format: :date },
          city: { type: :string },
          motorcycle_id: { type: :integer }
        },
        required: %w[reserve_date city motorcycle_id]
      }

      response '200', 'Reservation created successfully' do
        let(:reservation_attributes) { attributes_for(:reservation, user:) }
        let(:reservation) { reservation_attributes }

        before do
          post '/api/v1/reservations',
               params: { reservation: reservation_attributes },
               headers: auth_headers(user), as: :json
        end

        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     reserve_date: { type: :string, format: :date },
                     city: { type: :string },
                     motorcycle_id: { type: :integer }
                   },
                   required: %w[id reserve_date city motorcycle_id]
                 }
               },
               required: %w[status message data]

        run_test!
      end

      response '401', 'Unauthorized' do
        before { post '/api/v1/reservations' }

        examples 'application/json' => {
          status: 'Error',
          message: 'Unauthorized'
        }
      end

      response '422', 'Failed to create reservation' do
        let(:reservation_attributes) { { reserve_date: nil, city: nil, motorcycle_id: nil } }
        let(:reservation) { reservation_attributes }

        before do
          post '/api/v1/reservations',
               params: { reservation: reservation_attributes },
               headers: auth_headers(user)
        end

        examples 'application/json' => {
          status: 'Error',
          message: 'Failed to create reservation',
          errors: {
            reserve_date: ["can't be blank"],
            city: ["can't be blank"],
            motorcycle_id: ["can't be blank"]
          }
        }
      end
    end
  end

  path '/api/v1/reservations/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retrieve a specific reservation' do
      tags 'Reservations'
      security [bearerAuth: []]

      response '200', 'Reservation fetched successfully' do
        let(:reservation) { create(:reservation, user:) }
        let(:id) { reservation.id }

        before do
          get "/api/v1/reservations/#{id}", headers: auth_headers(user)
        end

        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     reserve_date: { type: :string, format: :date },
                     city: { type: :string },
                     motorcycle_id: { type: :integer }
                   },
                   required: %w[id reserve_date city motorcycle_id]
                 }
               },
               required: %w[status message data]

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { 1 }

        before { get "/api/v1/reservations/#{id}" }

        examples 'application/json' => {
          status: 'Error',
          message: 'Unauthorized'
        }
      end

      response '404', 'Reservation not found' do
        let(:id) { 999 }

        before do
          get "/api/v1/reservations/#{id}", headers: auth_headers(user)
        end

        examples 'application/json' => {
          status: 'Error',
          message: 'Reservation not found'
        }
      end
    end

    put 'Update a specific reservation' do
      tags 'Reservations'
      security [bearerAuth: []]

      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          reserve_date: { type: :string, format: :date },
          city: { type: :string },
          motorcycle_id: { type: :integer }
        },
        required: %w[reserve_date city motorcycle_id]
      }

      response '200', 'Reservation updated successfully' do
        let(:reservation) { create(:reservation, user:) }
        let(:id) { reservation.id }
        let(:updated_attributes) { { reserve_date: '2023-08-31', city: 'New City', motorcycle_id: 2 } }

        before do
          put "/api/v1/reservations/#{id}",
              params: { reservation: updated_attributes },
              headers: auth_headers(user), as: :json
        end

        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     reserve_date: { type: :string, format: :date },
                     city: { type: :string },
                     motorcycle_id: { type: :integer }
                   },
                   required: %w[id reserve_date city motorcycle_id]
                 }
               },
               required: %w[status message data]

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { 1 }
        let(:updated_attributes) { { reserve_date: '2023-08-31', city: 'New City', motorcycle_id: 2 } }

        before { put "/api/v1/reservations/#{id}", params: { reservation: updated_attributes } }

        examples 'application/json' => {
          status: 'Error',
          message: 'Unauthorized'
        }
      end

      response '422', 'Failed to update reservation' do
        let(:reservation) { create(:reservation, user:) }
        let(:id) { reservation.id }
        let(:updated_attributes) { { reserve_date: nil, city: nil, motorcycle_id: nil } }

        before do
          put "/api/v1/reservations/#{id}",
              params: { reservation: updated_attributes },
              headers: auth_headers(user), as: :json
        end

        examples 'application/json' => {
          status: 'Error',
          message: 'Failed to update reservation',
          errors: {
            reserve_date: ["can't be blank"],
            city: ["can't be blank"],
            motorcycle_id: ["can't be blank"]
          }
        }
      end
    end

    delete 'Delete a specific reservation' do
      tags 'Reservations'
      security [bearerAuth: []]

      response '200', 'Reservation deleted successfully' do
        let(:reservation) { create(:reservation, user:) }
        let(:id) { reservation.id }

        before do
          delete "/api/v1/reservations/#{id}", headers: auth_headers(user)
        end

        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     reserve_date: { type: :string, format: :date },
                     city: { type: :string },
                     motorcycle_id: { type: :integer }
                   },
                   required: %w[id reserve_date city motorcycle_id]
                 }
               },
               required: %w[status message data]

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { 1 }

        before { delete "/api/v1/reservations/#{id}" }

        examples 'application/json' => {
          status: 'Error',
          message: 'Unauthorized'
        }
      end

      response '404', 'Reservation not found' do
        let(:id) { 999 }

        before do
          delete "/api/v1/reservations/#{id}", headers: auth_headers(user)
        end

        examples 'application/json' => {
          status: 'Error',
          message: 'Reservation not found'
        }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
