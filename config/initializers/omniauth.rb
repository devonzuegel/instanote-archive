Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,    ENV['omniauth_provider_key'],   ENV['omniauth_provider_secret']
  provider :evernote,   ENV['en_consumer_key'],         ENV['en_secret_key'],   client_options: { site: ENV['en_oauth_site'] }
  provider :instapaper, ENV['instapaper_consumer_key'], ENV['instapaper_consumer_secret']
end