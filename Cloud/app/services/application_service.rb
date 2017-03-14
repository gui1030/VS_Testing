class ApplicationService
  def logger
    self.class.logger
  end

  class << self
    def logger
      Rails.logger
    end
  end
end
