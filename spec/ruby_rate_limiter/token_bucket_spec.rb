require 'spec_helper'
require 'ruby_rate_limiter/token_bucket'
require 'ruby_rate_limiter/storage/redis_storage'
require 'timecop'

RSpec.describe RubyRateLimiter::TokenBucket do
  let(:user_id) { 'user123' }
  let(:storage) { RubyRateLimiter::Storage::RedisStorage.new }
  let(:bucket) { RubyRateLimiter::TokenBucket.new(user_identifier: user_id, storage: storage, time_unit: :minute) }

  before do
    storage.set("#{user_id}_tokens", nil)
    storage.set("#{user_id}_last_refill", nil)
    bucket
  end

  it 'initializes bucket with default values' do
    expect(storage.get("#{user_id}_tokens").to_i).to eq(bucket.instance_variable_get(:@bucket_size))
    expect(storage.get("#{user_id}_last_refill").to_f).to be_within(1).of(Time.now.to_f)
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

    Timecop.travel(Time.now + 300)
    expect(bucket.allow_request?).to be true
  end

  it 'correctly refills tokens over specified time' do
    bucket.allow_request?
    Timecop.travel(Time.now + 60)
    bucket.allow_request?    
    expect(storage.get("#{user_id}_tokens").to_i).to eq(10 - 1)
  end

  it 'adjusts negative elapsed time to zero' do
    allow(Time).to receive(:now).and_return(Time.now - 1)
    expect { bucket.allow_request? }.not_to raise_error
  end

  it 'does not exceed the maximum bucket size' do
    Timecop.travel(Time.now + 600)
    bucket
    expect(storage.get("#{user_id}_tokens").to_i).to eq(bucket.instance_variable_get(:@bucket_size))
  end
end
