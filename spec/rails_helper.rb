require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true

  # for testing the api
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  # Adding automation
  # config.include Devise::Test::ControllerHelpers, type: :controller
  # config.include Devise::Test::IntegrationHelpers, type: :controller

  # Capybara.register_driver :chrome do |app|
  #   Capybara::Selenium::Driver.new(app, browser: :chrome)
  # end

  # Capybara.javascript_driver = :chrome
  # Capybara.default_driver = :chrome

end
