require "twitter"
require "./volte_factory.rb"
require "dotenv"

Dotenv.load

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["MY_CONSUMER_KEY"]
  config.consumer_secret     = ENV["MY_CONSUMER_SECRET"]
  config.access_token        = ENV["MY_ACCESS_TOKEN"]
  config.access_token_secret = ENV["MY_ACCESS_TOKEN_SECRET"]
end

vol = VolteFactory.new
time = Time.now.strftime("%m/%d %H:%M")
tweet = vol.get_zaiko("高津")
client.update(tweet)