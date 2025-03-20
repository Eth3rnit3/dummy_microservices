require 'json'

module ApiHelpers
  def parse_response(response)
    result = JSON.parse(response.body.read)
    [result['message'], result['email']]
  end
  
  def bad_request_error(message)
    status 400
    { error: message }.to_json
  end
  
  def success_response(message)
    status 201
    { status: message }.to_json
  end
end