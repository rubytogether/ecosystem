class ApplicationController < ActionController::Base
  rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_token

  def invalid_token
    render file: Rails.public_path.join('500.html'),
      status: :unprocessable_entity, layout: false
  end

  def not_found
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
