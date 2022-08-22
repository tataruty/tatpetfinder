require('simplecov')
require "bundler/setup"
require "tatpetfinder"

SimpleCov.start do
  coverage_dir(File.join('..', '..', '..', ENV['CIRCLE_ARTIFACTS'], 'coverage')) if ENV['CIRCLE_ARTIFACTS']
  minimum_coverage(100)
  add_filter('/spec/')
end

# loader.eager_load # optionally
require('webmock/rspec')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
