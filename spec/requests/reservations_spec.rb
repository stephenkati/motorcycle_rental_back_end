require 'rails_helper'

RSpec.describe '/reservations', type: :request do
  let(:user) { create(:user) }
  let(:motorcycle) { create(:motorcycle) }
  let(:reservation) { create(:reservation, user:, motorcycle:) }
  let(:valid_attributes) { create(:reservation) }
  let(:valid_headers) do
    {
      'Authorization' => "Bearer #{jwt_token}",
      'Content-Type' => 'application/json'
    }
  end

  let(:invalid_attributes) do
    {
      reservation: {
        reserve_date: '',
        city: '',
        motorcycle_id: ''
      }
    }
  end

  let(:invalid_headers) do
    {
      'Authorization' => 'Bearer invalid.token',
      'Content-Type' => 'application/json'
    }
  end

  def jwt_token
    payload = { user_id: user.id }
    JWT.encode(payload, 'secret')
  end

  describe 'GET /index' do
    it 'returns a list of reservations for a user' do
      create_list(:reservation, 3, user:, motorcycle:)

      get api_v1_user_reservations_path(user_id: user.id), headers: valid_headers, as: :json

      expect(response).to have_http_status(:ok)
      expect(json['data'].length).to eq(3)
    end

    it 'returns unauthorised when the header is invalid' do
      get api_v1_user_reservations_path(user_id: user.id), headers: invalid_headers, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get api_v1_user_reservation_path(user_id: user.id, id: reservation.id), headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it 'returns unauthorised when the header is invalid' do
      get api_v1_user_reservation_path(user_id: user.id, id: reservation.id), headers: invalid_headers, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it 'return not found if reservation id is non existent' do
      get api_v1_user_reservation_path(user_id: user.id, id: 999), headers: valid_headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Reservation' do
        expect do
          post api_v1_user_reservations_path(user_id: user.id),
               params: valid_attributes, headers: valid_headers, as: :json
        end.to change(Reservation, :count).by(2)
      end

      it 'renders a JSON response with the new reservation' do
        post api_v1_user_reservations_path(user_id: user.id),
             params: valid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'returns unauthorised when the header is invalid' do
        post api_v1_user_reservations_path(user_id: user.id),
             params: valid_attributes, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Reservation' do
        expect do
          post api_v1_user_reservations_path(user_id: user.id),
               params: invalid_attributes, headers: valid_headers, as: :json
        end.to change(Reservation, :count).by(0)
      end

      it 'renders a JSON response with errors for the new reservation' do
        post api_v1_user_reservations_path(user_id: user.id),
             params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          reservation: {
            reserve_date: Date.today + 2,
            city: 'Bogota',
            motorcycle_id: motorcycle.id
          }
        }
      end

      it 'updates the requested reservation' do
        patch api_v1_user_reservation_path(user_id: user.id, id: reservation.id),
              params: new_attributes, headers: valid_headers, as: :json
        reservation.reload
        expect(reservation.reserve_date).to eq(Date.today + 2)
      end

      it 'renders a JSON response with the reservation' do
        patch api_v1_user_reservation_path(user_id: user.id, id: reservation.id),
              params: new_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'returns unauthorised when the header is invalid' do
        patch api_v1_user_reservation_path(user_id: user.id, id: reservation.id),
              params: new_attributes, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the reservation' do
        patch api_v1_user_reservation_path(user_id: user.id, id: reservation.id),
              params: invalid_attributes, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested reservation' do
      delete api_v1_user_reservation_path(user_id: user.id, id: reservation.id), headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it 'returns unauthorised when the header is invalid' do
      delete api_v1_user_reservation_path(user_id: user.id, id: reservation.id), headers: invalid_headers, as: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it 'return not found if reservation id is non existent' do
      delete api_v1_user_reservation_path(user_id: user.id, id: 999), headers: valid_headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end
