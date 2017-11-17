module HealthCheck
  class SidekiqQueueHealthCheck
    require 'sidekiq/api'

    extend BaseHealthCheck

    def self.check
      unless defined?(::Sidekiq)
        raise "Wrong configuration. Missing 'sidekiq' gem"
      end
      ::Sidekiq::Queue.new.size <= 50 ? '' : "Sidekiq Queue is too big! Size: #{::Sidekiq::Queue.new.size}"
    rescue Exception => e
      create_error 'sidekiq-queue', e.message
    end
  end
end
