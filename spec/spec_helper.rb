$LOAD_PATH.unshift File.expand_path('../app', __dir__)
require 'rack/test'

TestInternetSession = Struct.new :app do
  include Rack::Test::Methods
end

RSpec.configure do |config|
  config.fail_fast = true
  config.color     = true
  config.formatter = 'documentation'
end
