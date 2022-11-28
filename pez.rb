# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'aws-sdk-sts'
require 'debug'

# Pez is used to work with SQS on Aws
class Pez
  def initialize; end

  def list_queue_attributes
    attributes = sqs_client.get_queue_attributes(
      queue_url: queue_url,
      attribute_names: ['All']
    )

    attributes.attributes.each do |key, value|
      puts "#{key}: #{value}"
    end
  rescue StandardError => e
    puts e.message
  end

  def send_message(message_body, message_group_id)
    sqs_client.send_message(
      queue_url: queue_url,
      message_body: message_body,
      message_group_id: message_group_id
    )
  rescue StandardError
    puts e.message
  end

  def receive_messages(count)
    return false if count > 10

    sqs_client
      .receive_message({
                         queue_url: queue_url,
                         attribute_names: ['All'],
                         max_number_of_messages: count
                       })
  end

  def next_message
    receive_messages(1)
  end

  def delete_message(receipt_handle)
    sqs_client
      .delete_message({
                        queue_url: queue_url,
                        receipt_handle: receipt_handle
                      })
  end

  def pop_message
    message = next_message

    delete_message(message.messages[0].receipt_handle)

    message
  end

  private

  def sqs_client
    @sqs_client ||= Aws::SQS::Client.new(region: region)
  end

  def sts_client
    @sts_client ||= Aws::STS::Client.new(region: region)
  end

  def region
    ENV['AWS_REGION']
  end

  def queue_name
    ENV['AWS_QUEUE_NAME']
  end

  def queue_url
    "https://sqs.#{region}.amazonaws.com/#{sts_client.get_caller_identity.account}/#{queue_name}"
  end
end
