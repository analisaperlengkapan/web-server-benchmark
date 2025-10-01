require 'sinatra'
require 'json'

set :bind, '0.0.0.0'
set :port, 8080

get '/hello' do
  content_type :json
  { message: 'Hello, world!' }.to_json
end
