# frozen_string_literal: true

require "rate_limiter"
require 'pry'
require 'timecop'


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.before(:each) do
    Timecop.return
  end

  config.after(:each) do
    Timecop.return
  end
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
