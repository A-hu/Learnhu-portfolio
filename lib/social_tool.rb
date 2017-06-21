module SocialTool
  def self.twitter_search field, amount, status
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch("TWITTER_CONSUMER_KEY")
      config.consumer_secret     = ENV.fetch("TWITTER_CONSUMER_SECRET")
      config.access_token        = ENV.fetch("TWITTER_ACCESS_TOKEN")
      config.access_token_secret = ENV.fetch("TWITTER_ACCESS_SECRET")
    end

  client.search(field, result_type: status).take(amount).collect do |tweet|
    "#{tweet.user.screen_name}: #{tweet.text}"
  end
  end
end
