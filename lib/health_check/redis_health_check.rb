module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    def self.check
      unless defined?(::Redis)
        raise "Wrong configuration. Missing 'redis' gem"
      end
      cli = ::Redis.new(url: ENV["REDIS_URL"], password: ENV["REDIS_PASS"])
      res = cli.ping
      cli.quit
      res == 'PONG' ? '' : "Redis.ping returned #{res.inspect} instead of PONG"
    rescue Exception => e
      create_error 'redis', e.message
    end
  end
end
