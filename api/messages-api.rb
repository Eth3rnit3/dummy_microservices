require 'sinatra'
require_relative 'api_helpers'
require_relative 'bunny_helpers'

include ApiHelpers
include BunnyHelpers

set :port, 3000
set :bind, '0.0.0.0'

# API endpoint for messages
post '/api/messages' do
  content_type :json
  
  message, email = parse_response(request)
  
  if message.nil? || message.empty?
    return bad_request_error('Message is required')
  end
  
  connection.start
  publish_rabbit_message(message)
  
  success_response('Message sent successfully')
end
