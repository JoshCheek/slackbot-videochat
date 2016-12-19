require 'spec_helper'
require 'add_keys'
require 'add_timestamp'

class EnvRecorder
  def call(env)
    @recorded_env = env
    [200, {}, []]
  end

  def [](key)
    @recorded_env[key]
  end
end

RSpec.describe 'Middleware' do
  let(:env_recorder) { EnvRecorder.new }

  def make_request(app)
    TestInternetSession.new(app).get('/')
  end

  describe AddKeys do
    it 'adds a hash of keys to env under the key :keys' do
      make_request env_recorder
      expect(env_recorder[:keys]).to eq nil

      make_request AddKeys.new(env_recorder, a: {b: 1})
      expect(env_recorder[:keys]).to eq a: { b: 1 }
    end
  end

  describe AddTimestamp do
    it 'adds the current time to the :timestamp key' do
      expected_time = Time.now
      time_class    = double(Time, now: expected_time)

      make_request env_recorder
      expect(env_recorder[:timestamp]).to eq nil

      make_request AddTimestamp.new(env_recorder, time_class)
      expect(env_recorder[:timestamp]).to eq expected_time
    end
  end
end
