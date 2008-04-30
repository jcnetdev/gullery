ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  include AuthenticatedTestHelper
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :users, :projects, :assets

  # Add more helper methods to be used by all tests here...
    
end
