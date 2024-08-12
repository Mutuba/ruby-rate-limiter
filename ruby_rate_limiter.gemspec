# frozen_string_literal: true

require_relative "lib/ruby_rate_limiter/version"

Gem::Specification.new do |spec|
  spec.name = 'ruby_rate_limiter'
  spec.version = RateLimiter::VERSION
  spec.authors = ["Mutuba"]
  spec.email = ["danielmutubait@gmail.com"]

  spec.summary       = 'Rate Limiter using Token Bucket Algorithm'
  spec.description   = 'A Ruby gem for rate limiting using the token bucket algorithm.'
  spec.homepage = "https://github.com/Mutuba/ruby-rate-limiter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.homepage = "https://github.com/Mutuba/ruby-rate-limiter"
  spec.metadata["changelog_uri"] = "https://github.com/Mutuba/ruby-rate-limiter/blob/main/CHANGELOG.md"

  spec.files         = Dir['lib/**/*', 'README.md', 'LICENSE']
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"
end
