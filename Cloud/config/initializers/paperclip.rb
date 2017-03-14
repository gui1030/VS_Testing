class Paperclip::Deprecations
  if Paperclip::VERSION < '5'
    def self.warn_aws_sdk_v1
      # Shut the fuck up about AWS
    end
  end
end
