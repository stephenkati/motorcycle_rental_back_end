require 'rails_helper'

RSpec.describe '/motorcycles', type: :request do
  let(:motorcycle) { create(:motorcycle) }

  let(:valid_attributes) do
    {
      motorcycle: {
        name: 'motorcycle',
        photo: 'motorcycle photo',
        description: 'motocycle description',
        purchase_price: 4000,
        rental_price: 500
      }
    }
  end

  let(:invalid_attributes) do
    {
      motorcycle: {
        name: '',
        photo: '',
        description: '',
        purchase_price: '',
        rental_price: ''
      }
    }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get api_v1_motorcycles_path, as: :json
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Success')
      expect(json_response['message']).to eq('Motorcycles fetched successfully')
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get api_v1_motorcycles_path(motorcycle), as: :json
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Success')
      expect(json_response['message']).to eq('Motorcycles fetched successfully')
    end

    it 'returns a 404 status when the requested motorcycle does not exist' do
      non_existent_id = Motorcycle.maximum(:id).to_i + 1
      get api_v1_motorcycle_path(non_existent_id), as: :json
      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Error')
      expect(json_response['message']).to eq('Failed to fetch motorcycle!')
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Motorcycle' do
        expect do
          post api_v1_motorcycles_path,
               params: valid_attributes, as: :json
        end.to change(Motorcycle, :count).by(1)

        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('Success')
        expect(json_response['message']).to eq('Motorcycle created successfully')
      end

      it 'renders a JSON response with the new motorcycle' do
        post api_v1_motorcycles_path,
             params: valid_attributes, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Motorcycle' do
        expect do
          post api_v1_motorcycles_path,
               params: invalid_attributes, as: :json
        end.to change(Motorcycle, :count).by(0)

        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('Error')
        expect(json_response['message']).to eq('Failed to create motorcycle!')
      end

      it 'renders a JSON response with errors for the new motorcycle' do
        post api_v1_motorcycles_path,
             params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'PATCH /update' do
    let(:motorcycle) { create(:motorcycle) }

    context 'with valid parameters' do
      let(:new_attributes) do
        {
          motorcycle: {
            name: 'motorcycle 2',
            photo: 'motorcycle photo 2',
            description: 'motocycle description 2',
            purchase_price: 2000,
            rental_price: 200
          }
        }
      end

      it 'renders a JSON response with the motorcycle' do
        patch api_v1_motorcycle_path(motorcycle),
              params: new_attributes, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including('application/json'))

        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq('Success')
        expect(json_response['message']).to eq('Motorcycle updated successfully')
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the motorcycle' do
        patch api_v1_motorcycle_path(motorcycle),
              params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:motorcycle) { create(:motorcycle) }

    it 'destroys the requested motorcycle' do
      expect do
        delete "/api/v1/motorcycles/#{motorcycle.id}", as: :json
      end.to change(Motorcycle, :count).by(-1)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Success')
      expect(json_response['message']).to eq('Motorcycle deleted successfully')
    end
  end

  describe 'DELETE /destroy' do
    it 'returns a 404 status when trying to delete a non-existent motorcycle' do
      non_existent_id = Motorcycle.maximum(:id).to_i + 1
      expect do
        delete "/api/v1/motorcycles/#{non_existent_id}", as: :json
      end.not_to change(Motorcycle, :count)

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Error')
      expect(json_response['message']).to eq('Motorcycle not found!')
    end
  end

  describe 'DELETE /destroy' do
    let!(:motorcycle) { create(:motorcycle) }

    before do
      allow_any_instance_of(Motorcycle).to receive(:destroy).and_return(false)
    end

    it 'returns a 422 status when there is an error during motorcycle deletion' do
      expect do
        delete "/api/v1/motorcycles/#{motorcycle.id}", as: :json
      end.not_to change(Motorcycle, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('Error')
      expect(json_response['message']).to eq('Failed to delete motorcycle!')
    end
  end
end
