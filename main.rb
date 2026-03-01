require 'dotenv/load'
require 'discordrb'

require './commands/campaigns'

token = ENV['DISCORD_TOKEN']
server_id = ENV['SERVER_ID']

bot = Discordrb::Bot.new(
  token: token,
  intents: [:direct_messages]
)

bot.include! Campaigns

bot.ready do
  # /ping
  bot.register_application_command(:ping, 'Check if the bot is alive', server_id: server_id)

  # /create_campaign <campaign name>
  bot.register_application_command(:create_campaign, 'Create a new DnD campaign to store characters in', server_id: server_id) do |conf|
    conf.string('name', 'The name of the campaign', required: false)
  end

  # /remove_campaign
  bot.register_application_command(:remove_campaign, 'Remove the campaign assigned to this channel and all the associated characters', server_id: server_id)
end

bot.application_command(:ping) do |event|
  event.respond(content: "Pong")
end

bot.run
