class InstapaperClient
  def initialize(instapaper_account)
    @credentials = {
      consumer_key:       ENV['instapaper_consumer_key'],
      consumer_secret:    ENV['instapaper_consumer_secret'],
      oauth_token:        instapaper_account.token,
      oauth_token_secret: instapaper_account.secret
    }
    @client = Instapaper::Client.new(@credentials)
    @client.verify_credentials
    puts @client.bookmarks
  end
end
