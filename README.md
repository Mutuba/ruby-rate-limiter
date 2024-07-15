# Ruby Rate Limiter

`ruby_rate_limiter` is a Ruby gem that implements a rate limiting mechanism using the Token Bucket algorithm. This gem allows you to control the rate of requests from users or clients, which can be useful for API rate limiting, request throttling, and more.

## Features

- Token Bucket Algorithm: A flexible and efficient algorithm for rate limiting.
- Redis Backend: Utilizes Redis for token storage and management.
- Customizable Parameters: Configure the bucket size and refill rate to meet your needs.
- Supports Time Travel: For easier testing with time manipulation.

## Installation

Add `ruby_rate_limiter` to your application's Gemfile:

```ruby
gem 'ruby_rate_limiter'

```

Then run:

```ruby
bundle install
```

Alternatively, you can install the gem directly using:

```ruby
gem install ruby_rate_limiter
```

## Usage

### Configuration

First, configure the RateLimiter::TokenBucket with a unique identifier for each user and specify the storage backend (e.g., Redis).

Create a file in the initialize directory

```ruby
# config/initializers/ruby_rate_limiter.rb
require 'ruby_rate_limiter'
require 'redis'

module RateLimiter
  DEFAULT_BUCKET_SIZE = 10
  DEFAULT_REFILL_RATE = 1
  DEFAULT_TIME_UNIT = :minute

  def self.for(user_identifier:, bucket_size: DEFAULT_BUCKET_SIZE, refill_rate: DEFAULT_REFILL_RATE, time_unit: DEFAULT_TIME_UNIT)
    RubyRateLimiter::TokenBucket.new(
      user_identifier: user_identifier,
      storage: RubyRateLimiter::Storage::RedisStorage.new(redis_client),
      bucket_size: bucket_size,
      refill_rate: refill_rate,
      time_unit: time_unit
    )
  end

  private

  def self.redis_client
    @redis_client ||= Redis.new(url: ENV['REDIS_URL'])
  end
end



```

### Usage somewhere, in the controller or better still in a service

Maybe have some service

```ruby
class RateLimiterService
  def self.rate_limit_exceeded?(user_identifier)
    rate_limiter = RateLimiter.for(user_identifier: user_identifier)
    !rate_limiter.allow_request?
  end
end

```

Usage in the controller

```ruby
class SomeController < ApplicationController
  def some_action
    user_identifier = current_user ? "user:#{current_user.id}" : "ip:#{request.remote_ip}"
    if RateLimiterService.rate_limit_exceeded?(user_identifier)
      render status: 429, json: { error: 'Too many requests' }
    else
      # Process the request
      render json: { message: 'Request processed' }
    end
  end
end

Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/Mutuba/ruby-rate-limiter.

License
The gem is available as open source under the terms of the MIT License.
```
