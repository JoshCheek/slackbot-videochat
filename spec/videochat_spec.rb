# require 'videochat_app'

RSpec.describe 'VideochatApp' do
  describe 'when Slack POSTs to /videochats' do
    it 'responds with a link to a url that the users can videochat'

    describe 'the videochat link' do
      it 'is on the app\'s host'
      it 'is a unique url so that users don\'t all wind up in the same chat'
    end
  end


  describe 'when users follow a videochat link' do
    it 'provides a twilio video token'
    it 'gets the room name from the url'

    # Instructions to get keys are here:
    # https://github.com/TwilioDevEd/video-quickstart-ruby
    describe 'the token' do
      it 'depends on a unique identity (random value for now)'
      it 'depends on the profile sid'
      it 'depends on the account sid'
      it 'depends on the api key'
      it 'depends on the api secret'
    end
  end
end
