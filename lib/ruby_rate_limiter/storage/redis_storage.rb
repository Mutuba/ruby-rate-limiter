require 'redis'
require_relative 'abstract_storage'

module RubyRateLimiter
  module Storage
    class RedisStorage < AbstractStorage
      def initialize
        @redis = Redis.new
      end

      def get(key)
        @redis.get(key)
      end

      def set(key, value)
        @redis.set(key, value)
      end
    end
  end
end
