require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    # for testing action mailer
    # @emails = ActionMailer::Base.deliveries 
    # @emails.clear
  end

  def test_should_login_and_redirect
    post :login, :login => 'quentin', :password => 'quentin'
    assert session[:user]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :login, :login => 'quentin', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
  end

  def test_should_allow_signup_if_no_other_users
    User.find(1).destroy
    old_count = User.count
    create_user
    assert_response :redirect
    assert_equal old_count+1, User.count
  end

  def test_should_require_login_on_signup
    User.find(1).destroy
    old_count = User.count
    create_user(:login => nil)
    assert assigns(:user).errors.on(:login)
    assert_response :success
    assert_equal old_count, User.count
  end

  def test_should_require_password_on_signup
    User.find(1).destroy
    old_count = User.count
    create_user(:password => nil)
    assert assigns(:user).errors.on(:password)
    assert_response :success
    assert_equal old_count, User.count
  end

  def test_should_require_password_confirmation_on_signup
    User.find(1).destroy
    old_count = User.count
    create_user(:password_confirmation => nil)
    assert assigns(:user).errors.on(:password_confirmation)
    assert_response :success
    assert_equal old_count, User.count
  end

  def test_should_reject_extra_logins
    old_count = User.count
    create_user
    assert_response :redirect
  end


  def test_should_logout
    login_as :quentin
    get :logout
    assert_nil session[:user]
    assert_response :redirect
  end

protected

  def create_user(options = {})
    post :signup, :user => { :name => 'Quire Jamison', :login => 'quire', :email => 'quire@example.com', 
                             :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end
