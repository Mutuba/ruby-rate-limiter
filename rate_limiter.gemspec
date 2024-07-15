# frozen_string_literal: true

require_relative "lib/rate_limiter/version"

Gem::Specification.new do |spec|
  spec.name = "rate_limiter"
  spec.version = RateLimiter::VERSION
  spec.authors = ["Mutuba"]
  spec.email = ["danielmutubait@gmail.com"]

  spec.summary = "Write a short summary, because RubyGems requires one."
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://github.com/Mutuba/rate-limiter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.homepage = "https://github.com/Mutuba/rate-limiter"
  spec.metadata["changelog_uri"] = "https://github.com/Mutuba/limiter/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir.chdir(__dir__) do
  #   `git ls-files -z`.split("\x0").reject do |f|
  #     (File.expand_path(f) == __FILE__) ||
  #       f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
  #   end
  # end
  spec.files         = Dir["lib/**/*.rb"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis"
end
