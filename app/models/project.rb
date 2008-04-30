class Project < ActiveRecord::Base

  validates_presence_of :user_id, :name
  validates_associated :user

  belongs_to :user
  has_many :assets, :order => 'position, created_at', :dependent => true

  acts_as_taggable

  def visible_assets
    self.assets.inject([]) {|ary, asset| asset.is_visible ? ary << asset : ary }
  end

  def poster_asset
    assets.count > 0 ? assets.first : Asset.new(:path => '/images/overlay.png')
  end

end
