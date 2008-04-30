require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < Test::Unit::TestCase
  fixtures :projects, :users, :assets

  def test_create_project
    assert create_project.valid?
  end

  def test_should_require_name
    p = create_project(:name => nil)
    assert p.errors.on(:name)
  end

  def test_should_require_user_id
    p = create_project(:user_id => nil)
    assert p.errors.on(:user_id)
  end

  def test_should_show_only_visible_assets
    p = Project.find 1
    assert_equal 5, p.assets.length
    assert_equal 3, p.visible_assets.length
    # TODO assert_equal [assets(:person_drinking), assets(:can_label), assets(:closeup)], p.visible_assets
  end

# BUG: Not working...slips through with no errors
#   def test_should_reject_non_existent_user
#     p = create_project(:user_id => 42)
#     assert p.errors.on(:user_id)
#   end


# 
#   def test_should_reset_password
#     users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
#     assert_equal users(:quentin), User.authenticate('quentin', 'new password')
#   end
# 
#   def test_should_not_rehash_password
#     users(:quentin).update_attributes(:login => 'quentin2')
#     assert_equal users(:quentin), User.authenticate('quentin2', 'quentin')
#   end
# 
#   def test_should_authenticate_user
#     assert_equal users(:quentin), User.authenticate('quentin', 'quentin')
#   end

protected

  def create_project(options = {})
    Project.create({ :name => 'Cloneberry Cobbler', :user_id => 1 }.merge(options))
  end

end
