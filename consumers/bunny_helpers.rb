require 'json'
require 'bunny'

module BunnyHelpers
  def connection
    @connection ||= Bunny.new(hostname: 'rabbitmq')
  end

  def channel
    @channel ||= connection.create_channel
  end

  def queue
    @queue ||= channel.queue('operations.messages', durable: true)
  end

  def exchange
    @exchange ||= channel.default_exchange
  end

  def publish_rabbit_message(message)
    exchange.publish(
      { message: message }.to_json,
      routing_key: queue.name,
      persistent: true
    )
    puts "Published message: #{message}"

    # Close connection
    connection.close
  end
end
