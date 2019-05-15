require "./volte_factory.rb"
require "traq_webhook"
require "dotenv"

Dotenv.load

vol = VolteFactory.new
client = TraqWebhook::Client.new do |config|
  config.id = ENV['TRAQ_WEBHOOK_ID']
  config.token = ENV['TRAQ_SECRET_TOKEN']
end

message = vol.get_zaiko("高津")
client.post(message)
