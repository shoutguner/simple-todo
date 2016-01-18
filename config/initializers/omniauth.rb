Rails.application.config.middleware.use OmniAuth::Builder do
                      #app_id              secret
  provider :facebook, '1633941720157354', ENV['SECRET_KEY_FACEBOOK']
end
