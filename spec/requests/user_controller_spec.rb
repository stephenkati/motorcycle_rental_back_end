RSpec.describe 'Users', type: :request do
  describe '#create' do
    let(:valid_user_params) do
      {
        user: {
          username: 'test_user',
          email: 'test_user@example.com',
          password: 'password'
        }
      }
    end

    before do
      post '/api/v1/users', params: valid_user_params
    end

    it 'returns username' do
      expect(json['user']['username']).to eq('test_user')
    end

    it 'returns email' do
      expect(json['user']['email']).to eq('test_user@example.com')
    end

    it 'does not return password' do
      expect(json['user']['password']).to be_nil
    end

    it 'returns a token' do
      expect(json['token']).not_to be_nil
    end

    it 'returns status :ok' do
      expect(response).to have_http_status(:ok)
    end
  end
end
