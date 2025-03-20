# Consumer messages on queue operations.messages

require 'bunny'
require 'json'
require 'net/http'
require 'uri'
require_relative 'bunny_helpers'

include BunnyHelpers

class MessagesConsumer
  def initialize
    connection.start
    @notifications_api_url = 'http://notifications-api:3001/api/notifications'
    
    # Ensure messages.txt file exists
    File.open('messages.txt', 'a') unless File.exist?('messages.txt')
  end
  
  def start
    puts " [*] Waiting for messages in #{queue.name}. To exit press CTRL+C"
    
    queue.subscribe(block: true) do |_delivery_info, _properties, body|
      process_message(body)
    end
  end
  
  def process_message(body)
    data = JSON.parse(body)
    message = data['message']
    
    puts " [x] Received message: #{message}"
    
    # Append message to database file
    File.open('/app/data/messages.txt', 'a') do |file|
      file.puts "#{Time.now}: #{message}"
    end
    
    # Forward to notifications API
    send_notification(message)
  end
  
  def send_notification(message)
    uri = URI.parse(@notifications_api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
    request.body = { message: message, email: 'user@example.com' }.to_json
    
    response = http.request(request)
    puts " [x] Notification sent: #{response.code}"
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

  @consumer = MessagesConsumer.new
  @consumer.start
end

start_consumer
