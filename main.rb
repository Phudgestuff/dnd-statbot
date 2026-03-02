require 'dotenv/load'
require 'discordrb'

require './commands/campaigns'
require './commands/characters'

token = ENV['DISCORD_TOKEN']
server_id = ENV['SERVER_ID']

bot = Discordrb::Bot.new(
  token: token,
  intents: [:direct_messages],
  log_mode: :error
)

bot.debug = false

bot.include! Campaigns
bot.include! Characters

bot.ready do
  # notation for myself to keep track of
  # /command_name <required command> </optional command/> ... <...>

  # /ping
  bot.register_application_command(:ping, 'Check if the bot is alive', server_id: server_id)

  # CAMPAIGNS
  # /create_campaign </campaign name/>
  bot.register_application_command(:create_campaign, 'Create a new DnD campaign to store characters in', server_id: server_id) do |conf|
    conf.string('name', 'The name of the campaign', required: true)
  end
  # /remove_campaign <campaign name>
  bot.register_application_command(:remove_campaign, 'Remove the campaign assigned to this channel and all the associated characters', server_id: server_id) do |conf|
    conf.string('name', 'The name of the campaign', required: true)
  end
  # /list_campaigns
  bot.register_application_command(:list_campaigns, 'List all campaigns', server_id: server_id)

  # CHARACTERS
  # /create_character <character name> <campaign>
  bot.register_application_command(:create_character, 'Create a character', server_id: server_id) do |conf|
    conf.string('name', 'The name of the character', required: true)
    conf.string('campaign', 'The name of the campaign that the character is a part of', required: true)
  end

  # /remove_character <campaign> <character name>
  bot.register_application_command(:remove_character, 'Remove a character', server_id: server_id) do |conf|
    conf.string('campaign', 'The name of the campaign that the character is a part of', required: true)
    conf.string('name', 'The name of the character', required: true)
  end
end

bot.application_command(:ping) do |event|
  event.respond(content: "Pong")
end

bot.run
