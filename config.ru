$LOAD_PATH.unshift('app', __dir__)
require 'slackbot_videochat'

class AddKeys
  def initialize(app, keys)
    @app  = app
    @keys = keys
  end

  def call(env)
    if env[:keys]
      require "pry"
      binding.pry
    end
    env[:keys] = @keys
    @app.call(env)
  end
end


require 'dotenv'
Dotenv.load
use AddKeys, {
  twilio: {
    account_sid:       ENV['TWILIO_ACCOUNT_SID'],
    api_key:           ENV['TWILIO_API_KEY'],
    api_secret:        ENV['TWILIO_API_SECRET'],
    configuration_sid: ENV['TWILIO_CONFIGURATION_SID'],
  }
}

run SlackbotVideochat
