class ApplicationController < ActionController::API
  def encoded_token(payload)
    JWT.encode(payload, 'secret')
  end

  def decode_token
    auth_header = request.headers['Authorization']

    return unless auth_header

    token = auth_header.split[1]
    begin
      JWT.decode(token, 'secret', true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def authorized_user
    decoded_token = decode_token

    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def authorize
    render json: { message: 'You have to Log In' }, status: :unauthorized unless authorized_user
  end
end
