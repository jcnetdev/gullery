require File.dirname(__FILE__) + '/../test_helper'

class AssetTest < Test::Unit::TestCase
  fixtures :assets, :projects

  def test_create_asset
    assert create_asset.valid?
  end

  def test_sizes
    asset = Asset.find 1
    assert_equal 'closeup_normal.png', asset.web_path
    assert_equal 'closeup_thumb.png', asset.web_path(:thumb)
    assert_equal 'closeup_normal.png', asset.web_path(:normal)
    assert_equal 'closeup.png', asset.web_path(:original)
  end

#   def test_should_require_name
#     p = create_project(:name => nil)
#     assert p.errors.on(:name)
#   end


protected

  def create_asset(options = {})
    Asset.create({ :path => 'image.jpg', :project_id => 1 }.merge(options))
  end

end
