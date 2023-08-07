require 'rails_helper'

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

    let(:invalid_user_params) do
      {
        user: {
          username: '',
          email: '',
          password: ''
        }
      }
    end

    before do
      post '/api/v1/users', params: valid_user_params
    end

    it 'creates a new user' do
      expect(User.count).to eq(1)
    end

    it 'response should be successful' do
      expect(response).to be_successful
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

    it 'returns status :unprocessable_entity if user is not created' do
      post '/api/v1/users', params: invalid_user_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#login' do
    let(:user_params) do
      {
        user: {
          username: 'test_user',
          email: 'test_user@example.com',
          password: 'password'
        }
      }
    end

    let(:valid_user_params) do
      {
        user: {
          username: 'test_user',
          password: 'password'
        }
      }
    end

    let(:invalid_user_params) do
      {
        user: {
          username: '',
          password: ''
        }
      }
    end

    let(:wrong_user_params) do
      {
        user: {
          username: 'test_user',
          password: 'wrong_password'
        }
      }
    end

    before do
      post '/api/v1/users', params: user_params
    end

    it 'should be successful with valid params' do
      post '/api/v1/login', params: valid_user_params
      expect(response).to have_http_status(:ok)
    end

    it 'should return a token with valid params' do
      post '/api/v1/login', params: valid_user_params
      expect(json['token']).not_to be_nil
    end

    it 'should return a user with valid params' do
      post '/api/v1/login', params: valid_user_params
      expect(json['user']).not_to be_nil
    end

    it 'should  return status 401 if user does not exist' do
      post '/api/v1/login', params: invalid_user_params
      expect(response).to have_http_status(401)
    end

    it 'should return status 401 if user password does not match' do
      post '/api/v1/login', params: wrong_user_params
      expect(response).to have_http_status(401)
    end
  end
end
