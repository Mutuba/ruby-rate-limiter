# lib/ruby_rate_limiter/storage/redis_storage.rb
require 'redis'

module RubyRateLimiter
  module Storage
    class RedisStorage < AbstractStorage
      def initialize(redis_client = Redis.new)
        @redis = redis_client
      end

      def get(key)
        @redis.get(key)
      end

      def set(key, value)
        @redis.setnx(key, value)
      end

      def watch(key, &block)
        @redis.watch(key, &block)
      end

      def multi(&block)
        @redis.multi(&block)
      end
    end
  end
end
