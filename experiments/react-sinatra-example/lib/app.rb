require 'sinatra'

set :root, 'lib/app'

get '/' do
  @ruby_greeting = 'Hello from Ruby!'
  erb render :html, :index
end
