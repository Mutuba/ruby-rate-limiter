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
  def self.bucket
    @bucket ||= RubyRateLimiter::TokenBucket.new(
      'user123',
      storage: RubyRateLimiter::Storage::RedisStorage.new(redis_client),
      bucket_size: 10,   # Optional: specify bucket size
      refill_rate: 2     # Optional: specify refill rate (tokens per second)
    )
  end

  private

  def self.redis_client
    @redis_client ||= Redis.new(url: 'redis://localhost:6379/1')
  end
end

```

### Usage somewhere, in the controller or better still in a service

```ruby
class SomeController < ApplicationController
  def some_action
    if RateLimiter.bucket.allow_request?
      # Process the request
      render json: { message: 'Request processed' }
    else
      # Rate limit exceeded
      render status: 429, json: { error: 'Too many requests' }
    end
  end
end
```

```ruby
class SomeService
  def perform
    if RateLimiter.bucket.allow_request?
      # Process the request
      # Perform the service logic here
    else
      # Rate limit exceeded
      raise 'Too many requests'
    end
  end
end

```

Contributing
Bug reports and pull requests are welcome on GitHub at link(https://github.com/Mutuba/ruby-rate-limiter).

License
The gem is available as open source under the terms of the MIT License.
