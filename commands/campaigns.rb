require 'discordrb'
require_relative '../db/json_functions'

module Campaigns
  extend Discordrb::EventContainer

  application_command(:create_campaign) do |event|
    data = DB.get_data

    # otherwise set up the campaign entry
    campaign_name = event.options['name'] || event.channel.name # set the dnd name to the channel name if no name is provided

    if data.has_key? campaign_name
      event.respond content: "There is already a campaign with that name"
      return
    end

    data[campaign_name] = {}
    # write changes
    DB.update data

    # inform user of changes
    event.respond(content: "Created a DnD campaign called `#{campaign_name}`")
  end

  application_command(:remove_campaign) do |event|
    data = DB.get_data

    name = event.options['name']

    # check if a campaign exists in db
    unless data.key?(name)
      event.respond(content: "There is no campaign with that name", ephemeral: true)
      return
    end
    
    # implement confirmation buttons
    data.delete(name)

    DB.update data

    event.respond content: "Deleted campaign `#{name}`"
  end

  application_command(:list_campaigns) do |event|
    event.respond content: "List of all campaigns:\n```\n#{DB.get_data.keys.join("\n")}```"
  end
end
