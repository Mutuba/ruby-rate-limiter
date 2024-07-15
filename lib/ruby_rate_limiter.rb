# frozen_string_literal: true
# lib/ruby_rate_limiter.rb
require_relative "ruby_rate_limiter/version"
require 'ruby_rate_limiter/token_bucket'
require 'ruby_rate_limiter/storage/abstract_storage'
require 'ruby_rate_limiter/storage/redis_storage'


module RubyRateLimiter
  class Error < StandardError; end
end
