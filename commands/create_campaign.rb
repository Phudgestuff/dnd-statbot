require 'discordrb'

module CreateCampaign
  extend Discordrb::EventContainer

  application_command(:create_campaign) do |event|
    event.respond(content: "this command doesn't do anything yet...") # TODO make this do something
  end
end
