# lib/ruby_rate_limiter/storage/redis_storage.rb
require 'redis'

module RubyRateLimiter
  module Storage
    class RedisStorage
      attr_reader :redis

      def initialize(redis = Redis.new)
        @redis = redis
      end

      def get(key)
        redis.get(key)
      end

      def set(key, value)
        redis.set(key, value)
      end
    end
  end
end