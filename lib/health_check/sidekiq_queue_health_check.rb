module HealthCheck
  class SidekiqQueueHealthCheck
    require 'sidekiq/api'

    extend BaseHealthCheck

    def self.check
      unless defined?(::Sidekiq)
        raise "Wrong configuration. Missing 'sidekiq' gem"
      end
      size_of_all_queues = ::Sidekiq::Queue.all.map(&:size).inject(&:+)
      size_of_all_queues <= 50 ? '' : "Sidekiq Queue is too big! Size: #{size_of_all_queues}"
    rescue Exception => e
      create_error 'sidekiq-queue', e.message
    end
  end
end
