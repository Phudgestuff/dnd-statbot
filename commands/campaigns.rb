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

  application_command(:remove_campaign) do |event|
    data = DB.get_data
    channel_id = event.channel.id.to_s

    # check if a campaign exists in db
    unless data.key?(channel_id)
      event.respond(content: "There is no campaign assigned to this channel", ephemeral: true)
      return
    end
    
    # ask for confirmation with a button
    event.respond(
      content: "Are you sure you want to remove this campaign? (Called `#{data[channel_id]['name']}`)",
      components: Discordrb::Components::View.new { |view| 
        view.row do |row|
          row.button label: "Yes, I'm sure", style: :success, custom_id: "delete_campaign_confirmation_button"
          row.button label: "No, forget that", style: :danger, custom_id: "delete_campaign_disregard_button"
        end
      }
    )
  end

  button(custom_id: "delete_campaign_disregard_button") do |event|
    event.respond(content: "Deletion cancelled.")
  end

  button(custom_id: "delete_campaign_confirmation_button") do |event|
    data = DB.get_data
    channel_id = event.channel.id.to_s

    data.delete(channel_id)

    DB.update data

    event.respond(content: "Campaign deleted.")
  end
end
