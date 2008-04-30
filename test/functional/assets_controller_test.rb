require File.dirname(__FILE__) + '/../test_helper'
require 'assets_controller'

# Re-raise errors caught by the controller.
class AssetsController; def rescue_action(e) raise e end; end

class AssetsControllerTest < Test::Unit::TestCase

  def setup
    @controller = AssetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_restricted_create
    assert_requires_login() { post :create }
    assert_accepts_login(:quentin) { post :create, :name => 'Fox Tall Action Figure' }
  end

  def test_restricted_update_caption
    assert_requires_login() { post :update_caption, :id => 1, :value => 'A caption' }
    assert_accepts_login(:quentin) { post :update_caption, :id => 1, :value => 'The can...even closer' }
  end

  def test_restricted_destroy
    assert_requires_login() { get :destroy, :id => 1 }
    assert_accepts_login(:quentin) { get :destroy, :id => 1 }    
  end

  def test_restricted_sort
    assert_requires_login() { post :sort }
    assert_accepts_login(:quentin) { post :sort, :asset_list => [3, 2, 1] }
  end
  
  def test_create
    login_as :quentin
    post :create, :asset => { :project_id => 1, 
                    :caption => 'Cloneberry logo', 
                    :file_field => uploaded_file("photo.jpg","image/jpeg","photo_uploaded.jpg") 
                  }
    asset = Asset.find_by_caption('Cloneberry logo')

    assert File.exists?(asset.absolute_path(:original))
    assert File.exists?(asset.absolute_path(:normal))
    assert File.exists?(asset.absolute_path(:thumb))

    assert_response :redirect
    assert_redirected_to projects_url(:id => 1, :action => 'show')
    assert_not_nil assigns(:asset)
    assert assigns(:asset).valid?

    asset.destroy
  end
  
  def test_update_caption
    login_as :quentin
    post :update_caption, :id => 1, :value => 'Alternate logo on can'
    assert_response :success
    assert_not_nil assigns(:asset)
    assert assigns(:asset).valid?
    
    assert_equal 'Alternate logo on can', Asset.find(1).caption
  end

  def test_destroy
    login_as :quentin
    asset = Asset.find(1)
    project = asset.project
    old_count = project.assets.length
    post :destroy, :id => 1
    assert_response :success
    assert_equal 'text/javascript', @response.headers['Content-Type']
    
    assert_equal old_count - 1, project.assets.count
  end
  
  def test_rotate
    FileUtils.cp  File.expand_path("test/fixtures/files/photo.jpg", RAILS_ROOT), 
                  File.expand_path("public/system/photo.jpg", RAILS_ROOT)

    image = MiniMagick::Image.from_file(assets(:photo).absolute_path(:original))
    assert image.height < image.width

    login_as :quentin
    post :rotate, :id => 5, :direction => 'cw'
    
    image = MiniMagick::Image.from_file(assets(:photo).absolute_path(:original))
    assert image.height > image.width
    
    assert_redirected_to projects_url(:action => 'show', :id => 1)
    assets(:photo).destroy
  end

private

  def uploaded_file(tmp_filename, content_type, filename)
    t = Tempfile.new(filename);
    t.binmode
    path = File.expand_path("test/fixtures/files/" + tmp_filename, RAILS_ROOT)
    FileUtils.copy_file(path, t.path)
    (class << t; self; end).class_eval do
      alias local_path path
      define_method(:original_filename) {filename}
      define_method(:content_type) {content_type}
    end
    return t
  end

end
