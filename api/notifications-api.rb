require 'sinatra'
require_relative 'api_helpers'

include ApiHelpers

set :port, 3001
set :bind, '0.0.0.0'

# API endpoint for notifications
post '/api/notifications' do
  content_type :json
  
  message, email = parse_response(request)
  
  if message.nil? || message.empty?
    return bad_request_error('Message is required')
  end
  
  if email.nil? || email.empty?
    return bad_request_error('Email is required')
  end
  
  success_response('Notification sent successfully')
end