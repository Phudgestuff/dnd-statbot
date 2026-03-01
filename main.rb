require 'dotenv/load'
require 'discordrb'

require './commands/create_campaign'

token = ENV['DISCORD_TOKEN']
server_id = ENV['SERVER_ID']

bot = Discordrb::Bot.new(
  token: token,
  intents: [:direct_messages]
)

bot.include! CreateCampaign

bot.ready do
  bot.register_application_command(:ping, 'Check if the bot is alive', server_id: server_id)
  bot.register_application_command(:create_campaign, 'Create a new DnD campaign to store characters in', server_id: server_id)
end

bot.application_command(:ping) do |event|
  event.respond(content: "Pong")
end

bot.run
