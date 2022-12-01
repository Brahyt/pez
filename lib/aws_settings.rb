module Lib
  module AwsSettings
    def hello_world
      puts 'hello world'
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

    def sqs_client
      @sqs_client ||= Aws::SQS::Client.new(region: region)
    end

    def sts_client
      @sts_client ||= Aws::STS::Client.new(region: region)
    end
  end
end
