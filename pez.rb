# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'aws-sdk-sts'

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
    puts "Error getting queue attributes: #{e.message}"
  end

  def send_message(message_body, message_group_id)
    sqs_client.send_message(
      queue_url: queue_url,
      message_body: message_body,
      message_group_id: message_group_id
    )
  rescue StandardError
    false
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

pez = Pez.new

pez.send_message('Hey now', 1)
pez.list_queue_attributes

