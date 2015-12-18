Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['omniauth_provider_key'], ENV['omniauth_provider_secret']
end
