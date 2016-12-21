root_path = File.realdirpath __dir__
$LOAD_PATH.unshift File.join(root_path, 'app')
$LOAD_PATH.unshift File.join(root_path, 'lib')

require 'dotenv'
Dotenv.load

require 'middleware'
use Middleware::AddToEnv, keys: {
  twilio: {
    account_sid:       ENV.fetch('TWILIO_ACCOUNT_SID'),
    api_key:           ENV.fetch('TWILIO_API_KEY'),
    api_secret:        ENV.fetch('TWILIO_API_SECRET'),
    configuration_sid: ENV.fetch('TWILIO_CONFIGURATION_SID'),
  }
}


require 'videochat_app'
run VideochatApp
