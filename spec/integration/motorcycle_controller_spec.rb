require 'swagger_helper'
# rubocop:disable Metrics/BlockLength
describe 'Motorcycle Api' do
  let(:motorcycle_attributes) do
    {
      id: 1,
      name: 'Honda',
      photo: 'image_url',
      purchase_price: 10_000,
      rental_price: 100,
      description: 'Honda is a Japanese public multinational conglomerate corporation.'
    }
  end
  let(:id) { motorcycle.id }
  let!(:motorcycle) { Motorcycle.create!(motorcycle_attributes) }

  path '/api/v1/motorcycles' do
    get 'A list of motorcycles' do
      tags 'Motorcycle'
      produces 'application/json'

      response '200', 'Motorcycles fetched successfully' do
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
                       name: { type: :string },
                       photo: { type: :string },
                       purchase_price: { type: :number },
                       rental_price: { type: :number },
                       description: { type: :string }
                     },
                     required: %w[id name photo purchase_price rental_price description]
                   }
                 }
               },
               required: %w[status message data]

        examples 'application/json' => {
          status: 'Success',
          message: 'Motorcycles fetched successfully',
          data: [
            {
              id: 1,
              name: 'Honda',
              photo: 'image_url',
              purchase_price: 10_000,
              rental_price: 100,
              description: 'Honda is a Japanese public multinational conglomerate corporation.'
            },
            {
              id: 2,
              name: 'Yamaha',
              photo: 'image_url',
              purchase_price: 9500,
              rental_price: 90,
              description: 'Yamaha Corporation is a Japanese multinational corporation.'
            }
          ]
        }

        run_test!
      end

      response '400', 'Motorcycles not found' do
        examples 'application/json' => {
          status: 'Error',
          message: 'Failed to fetch motorcycles!',
          errors: 'Motorcycles not found!'
        }
      end
    end
  end

  path '/api/v1/motorcycles/{id}' do
    get 'A specific motorcycle' do
      tags 'Motorcycle'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Motorcycle fetched successfully' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     photo: { type: :string },
                     purchase_price: { type: :number },
                     rental_price: { type: :number },
                     description: { type: :string }
                   },
                   required: %w[id name photo purchase_price rental_price description]
                 }
               },
               required: %w[status message data]

        examples 'application/json' => {
          status: 'Success',
          message: 'Motorcycle fetched successfully',
          data: { id: 1,
                  name: 'Honda',
                  photo: 'image_url',
                  purchase_price: 10_000,
                  rental_price: 100,
                  description: 'Honda is a Japanese public multinational conglomerate corporation.' }
        }

        run_test!
      end

      response '404', 'Motorcycle not found' do
        examples 'application/json' => {
          status: 'Error',
          message: 'Failed to fetch motorcycle!',
          errors: 'Motorcycle not found!'
        }
      end
    end
  end

  path '/api/v1/motorcycles' do
    post 'Create a new motorcycle' do
      tags 'Motorcycle'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :motorcycle, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          photo: { type: :string },
          purchase_price: { type: :number },
          rental_price: { type: :number },
          description: { type: :string }
        },
        required: %w[name photo purchase_price rental_price description]
      }

      response '200', 'Motorcycle created successfully' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     photo: { type: :string },
                     purchase_price: { type: :number },
                     rental_price: { type: :number },
                     description: { type: :string }
                   },
                   required: %w[id name photo purchase_price rental_price description]
                 }
               },
               required: %w[status message data]

        examples 'application/json' => {
          status: 'Success',
          message: 'Motorcycle created successfully',
          data: {
            id: 1,
            name: 'Honda',
            photo: 'image_url',
            purchase_price: 10_000,
            rental_price: 100,
            description: 'Honda is a Japanese public multinational conglomerate corporation.'
          }
        }

        run_test!
      end

      response '422', 'Failed to create motorcycle' do
        examples 'application/json' => {
          status: 'Error',
          message: 'Failed to create motorcycle!',
          errors: 'Motorcycle not created!'
        }
      end
    end
  end

  path '/api/v1/motorcycles/{id}' do
    put 'Update a specific motorcycle' do
      tags 'Motorcycle'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :motorcycle, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          photo: { type: :string },
          purchase_price: { type: :number },
          rental_price: { type: :number },
          description: { type: :string }
        },
        required: %w[name photo purchase_price rental_price description]
      }

      response '200', 'Motorcycle updated successfully' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     photo: { type: :string },
                     purchase_price: { type: :number },
                     rental_price: { type: :number },
                     description: { type: :string }
                   },
                   required: %w[id name photo purchase_price rental_price description]
                 }
               },
               required: %w[status message data]

        examples 'application/json' => {
          status: 'Success',
          message: 'Motorcycle updated successfully',
          data: {
            id: 1,
            name: 'Honda',
            photo: 'image_url',
            purchase_price: 20_000,
            rental_price: 200,
            description: 'Honda is a Japanese public multinational conglomerate corporation.'
          }
        }

        run_test!
      end

      response '422', 'Failed to update motorcycle' do
        examples 'application/json' => {
          status: 'Error',
          message: 'Failed to update motorcycle!',
          errors: 'Motorcycle not updated!'
        }
      end
    end
  end

  path '/api/v1/motorcycles/{id}' do
    delete 'Delete a specific motorcycle' do
      tags 'Motorcycle'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'Motorcycle deleted successfully' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     photo: { type: :string },
                     purchase_price: { type: :number },
                     rental_price: { type: :number },
                     description: { type: :string }
                   },
                   required: %w[id name photo purchase_price rental_price description]
                 }
               },
               required: %w[status message data]

        examples 'application/json' => {
          status: 'Success',
          message: 'Motorcycle deleted successfully',
          data: {
            id: 1,
            name: 'Honda',
            photo: 'image_url',
            purchase_price: 10_000,
            rental_price: 100,
            description: 'Honda is a Japanese public multinational conglomerate corporation.'
          }
        }

        run_test!
      end

      response '404', 'Motorcycle not found' do
        examples 'application/json' => {
          status: 'Error',
          message: 'Motorcycle not found!',
          data: nil
        }
      end

      response '422', 'Failed to delete motorcycle' do
        examples 'application/json' => {
          status: 'Error',
          message: 'Failed to delete motorcycle!',
          errors: 'Motorcycle not deleted!'
        }
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
