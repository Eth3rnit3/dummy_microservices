require 'bunny'
require 'json'
require 'net/http'
require 'uri'
require_relative 'bunny_helpers'

include BunnyHelpers

class OperationsConsumer
  NOTIFICATIONS_API_URL = 'http://notifications-api:3001/api/notifications'
  
  def initialize
    connection.start
    
    File.open('operations.txt', 'a') unless File.exist?('operations.txt')
  end
  
  def start    
    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      process_message(body)
    end
  end
  
  def process_message(body)
    data = JSON.parse(body)
    message = data['message']
    
    File.open('/app/data/operations.txt', 'a') do |file|
      file.puts "#{Time.now}: #{message}"
    end
    
    send_notification(message)
  end
  
  def send_notification(message)
    uri           = URI.parse(NOTIFICATIONS_API_URL)
    http          = Net::HTTP.new(uri.host, uri.port)
    request       = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body  = { message: message, email: 'user@example.com' }.to_json
    
    http.request(request)
  rescue => e
    puts " [!] Error sending notification: #{e.message}"
  end
  
  def close
    connection.close
  end
end

def start_consumer
  at_exit { @consumer.close }
  trap('INT') { @consumer.close }
  trap('TERM') { @consumer.close }

  @consumer = OperationsConsumer.new
  @consumer.start
end

start_consumer
