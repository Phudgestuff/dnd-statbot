require 'discordrb'
require_relative '../db/json_functions'

module Characters
  extend Discordrb::EventContainer

  application_command(:create_character) do |event|
    name = event.options['name']
    campaign = event.options['campaign']

    data = DB.get_data
    # check if the campaign exists
    unless data.has_key? campaign
      event.respond content: "There is no campaign with this name", ephemeral: true
      return
    end

    # check if there already exists a character with this name
    if data[campaign].has_key? name
      event.respond content: "There already exists a character with this name", ephemeral: true
      return
    end

    # otherwise create a new character
    data[campaign][name] = {}

    DB.update data

    event.respond content: "New character created called `#{name}`"
  end
end
