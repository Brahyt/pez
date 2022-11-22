# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'aws-sdk-sts'

# Pez is used to work with SQS on Aws
class Pez
  def initialize; end

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

Pez.go
