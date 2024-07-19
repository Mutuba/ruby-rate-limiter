# lib/ruby_rate_limiter/token_bucket.rb
require 'forwardable'
require_relative 'storage/abstract_storage'
require_relative 'storage/redis_storage'

module RubyRateLimiter
  class TokenBucket
    extend Forwardable

    DEFAULT_BUCKET_SIZE = 10
    DEFAULT_REFILL_RATE = 1
    DEFAULT_STORAGE = RubyRateLimiter::Storage::RedisStorage.new
    TIME_UNITS = {
      second: 1,
      minute: 60,
      hour: 3600
    }.freeze

    def_delegators :@storage, :get, :set

    def initialize(
      user_identifier:,
      bucket_size: DEFAULT_BUCKET_SIZE,
      refill_rate: DEFAULT_REFILL_RATE,
      time_unit: :second,
      storage: DEFAULT_STORAGE
    )
      @user_id = user_identifier
      @bucket_size = bucket_size
      @refill_rate_per_second = refill_rate.to_f / TIME_UNITS[time_unit]
      @storage = storage
      initialize_bucket
    end

    def allow_request?
      refill_tokens
      tokens = get_bucket_size
      puts "Allow request: tokens before = #{tokens}" # Debugging line

      return false if tokens < 1

      update_bucket_size(tokens - 1)
      puts "Allow request: tokens after = #{get_bucket_size}" # Debugging line
      true
    end

    private

    def initialize_bucket
      if get_bucket_size.nil?
        update_bucket_size(@bucket_size)
        update_last_refill_time(Time.now.to_f)
      end
    end

    def get_bucket_size
      size = (@storage.get("#{@user_id}_tokens") || @bucket_size).to_i
      puts "get_bucket_size: #{@user_id}_tokens = #{size}" # Debugging line
      size
    end

    def get_last_refill_time
      last_refill = (@storage.get("#{@user_id}_last_refill") || Time.now.to_f).to_f
      puts "get_last_refill_time: #{@user_id}_last_refill = #{last_refill}" # Debugging line
      last_refill
    end

    def update_bucket_size(tokens)
      @storage.set("#{@user_id}_tokens", tokens)
    end

    def update_last_refill_time(timestamp)
      @storage.set("#{@user_id}_last_refill", timestamp)
    end

    def refill_tokens
      current_time = Time.now.to_f
      last_refill_time = get_last_refill_time
      elapsed_time = current_time - last_refill_time
      new_tokens = (elapsed_time * @refill_rate_per_second).to_i
      puts "Refill tokens: current_time = #{current_time}, last_refill_time = #{last_refill_time}, elapsed_time = #{elapsed_time}, new_tokens = #{new_tokens}" # Debugging line

      return if new_tokens <= 0

      tokens = [get_bucket_size + new_tokens, @bucket_size].min
      update_bucket_size(tokens)
      update_last_refill_time(current_time)
      puts "Refill tokens: updated tokens = #{tokens}, current_time = #{current_time}" # Debugging line
    end
  end
end

