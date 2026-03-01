require 'discordrb'
require_relative '../db/json_functions'

module Campaigns
  extend Discordrb::EventContainer

  application_command(:create_campaign) do |event|
    data = DB.get_data

    # notify the user if the campaign has already been created
    if data.key?(event.channel.id)
      event.respond(content: "A campaign has already been assigned to this channel", ephemeral: true)
      return
    end

    # otherwise set up the campaign entry
    campaign_name = event.options['name'] || event.channel.name # set the dnd name to the channel name if no name is provided

    data[event.channel.id] = {name: campaign_name}
    # write changes
    DB.update data

    # inform user of changes
    event.respond(content: "Created a DnD campaign called `#{campaign_name}` and assigned it to this channel")
  end
end
