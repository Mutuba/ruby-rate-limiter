require 'spec_helper'
require 'ruby_rate_limiter/token_bucket'
require 'ruby_rate_limiter/storage/redis_storage'

RSpec.describe RubyRateLimiter::TokenBucket do
  let(:user_id) { 'user123' }
  let(:storage) { RubyRateLimiter::Storage::RedisStorage.new }
  let(:bucket) { described_class.new(user_id, storage: storage) }

  before do
    storage.set("#{user_id}_tokens", nil)
    storage.set("#{user_id}_last_refill", nil)
  end

  it 'allows requests within the rate limit' do
    10.times do
      expect(bucket.allow_request?).to be true
    end
    expect(bucket.allow_request?).to be false
  end

  it 'refills tokens over time' do
    10.times do
      bucket.allow_request?
    end
    expect(bucket.allow_request?).to be false

    Timecop.travel(Time.now + 3000) # travel 5 minutes ahead
    expect(bucket.allow_request?).to be true
  end
end
