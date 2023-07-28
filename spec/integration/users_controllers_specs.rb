require 'swagger_helper'
# rubocop:disable Metrics/BlockLength
describe 'Users Api' do
  path '/api/v1/users' do
    post 'Create a new user' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[username email password]
      }

      response '200', 'User created' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     username: { type: :string },
                     email: { type: :string },
                     password_digest: { type: :string },
                     created_at: { type: :string },
                     updated_at: { type: :string }
                   },
                   required: %w[id username email password_digest created_at updated_at]
                 },
                 token: { type: :string }
               },
               required: %w[status user token]

        examples 'application/json' => {
          status: 'Success',
          user: {
            id: 1,
            username: 'john doe',
            email: 'john@example.com',
            password_digest: '<PASSWORD_DIGEST>',
            created_at: Time.now.to_s,
            updated_at: Time.now.to_s
          },
          token: 'some-token'
        }

        let(:user) { { username: 'john doe', email: 'john@example.com', password: '<PASSWORD>' } }
        run_test!
      end

      response '422', 'Invalid request' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 errors: { type: :array }
               },
               required: %w[status message errors]

        examples 'application/json' => {
          status: 'Error',
          message: 'Invalid credentials',
          errors: ['<ERRORS>']
        }

        let(:user) { { username: 'john doe', email: 'john@example.com', password: '<PASSWORD>' } }
        run_test!
      end
    end
  end

  path '/api/v1/login' do
    post 'User login' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          password: { type: :string }
        },
        required: %w[username password]
      }

      response '200', 'User logged in successfully' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     username: { type: :string },
                     email: { type: :string },
                     password_digest: { type: :string },
                     created_at: { type: :string },
                     updated_at: { type: :string }
                   },
                   required: %w[id username email password_digest created_at updated_at]
                 },
                 token: { type: :string }
               },
               required: %w[status message user token]

        examples 'application/json' => {
          status: 'Success',
          message: 'Successfully logged In',
          user: {
            id: 1,
            username: 'john doe',
            email: 'john@example.com',
            password_digest: '<PASSWORD_DIGEST>',
            created_at: Time.now.to_s,
            updated_at: Time.now.to_s
          },
          token: 'some-token'
        }

        let(:user) { { username: 'john doe', password: '<PASSWORD>' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                 status: { type: :string },
                 message: { type: :string }
               },
               required: %w[status message]

        examples 'application/json' => {
          status: 'Error',
          message: 'Invalid credentials'
        }

        let(:user) { { username: 'john doe', password: '<INVALID_PASSWORD>' } }
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
