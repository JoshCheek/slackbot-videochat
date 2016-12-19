require 'spec_helper'
require 'add_keys'

RSpec.describe AddKeys do
  it 'adds a hash of keys to env under the key :keys' do
    recorded_env = nil
    app = lambda { |env| recorded_env = env; [200,{},[]] }
    app = AddKeys.new(app, a: {b: 1})
    TestInternetSession.new(app).get('/')
    expect(recorded_env[:keys]).to eq a: { b: 1 }
  end
end
