# Ruby Rate Limiter

ruby_rate_limiter is a Ruby gem that implements a rate limiting mechanism using the Token Bucket algorithm. This gem allows you to control the rate of requests from users or clients, which can be useful for API rate limiting, request throttling, and more.

## Features

- Token Bucket Algorithm: A flexible and efficient algorithm for rate limiting.
- Redis Backend: Utilizes Redis for token storage and management.
- Customizable Parameters: Configure the bucket size and refill rate to meet your needs.
- Supports Time Travel: For easier testing with time manipulation.

## Installation

```
Add `ruby_rate_limiter` to your application's Gemfile:
```
