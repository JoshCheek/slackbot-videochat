root = File.expand_path __dir__
$LOAD_PATH.unshift(File.join 'app')
$LOAD_PATH.unshift(File.join 'lib')

require 'dotenv'
Dotenv.load

require 'add_keys'
use AddKeys, {
  twilio: {
    account_sid:       ENV.fetch('TWILIO_ACCOUNT_SID'),
    api_key:           ENV.fetch('TWILIO_API_KEY'),
    api_secret:        ENV.fetch('TWILIO_API_SECRET'),
    configuration_sid: ENV.fetch('TWILIO_CONFIGURATION_SID'),
  }
}

require 'add_timestamp'
use AddTimestamp, Time

require 'slackbot_videochat'
run SlackbotVideochat
