class AddBasics < ActiveRecord::Migration
  def self.up
    create_table "projects", :force => true do |t|
      t.column "user_id", :integer
      t.column "name", :string
      t.column "is_visible", :boolean, :default => true
      t.column "created_at",       :datetime
      t.column "updated_at",       :datetime
      t.column "position", :integer
      t.column "description",       :text
    end
    
    create_table "assets", :force => true do |t|
      t.column "project_id", :integer
      t.column "path", :string
      t.column "caption", :string
      t.column "type", :string, :limit => 40
      t.column "is_visible", :boolean, :default => true
      t.column "created_at",       :datetime
      t.column "updated_at",       :datetime
      t.column "position", :integer
    end
    
    create_table "tags", :force => true do |t|
      t.column "name", :string
    end

    create_table "tags_assets", :force => true, :id => false do |t|
      t.column "tag_id", :integer
      t.column "asset_id", :integer
    end

    create_table "tags_projects", :force => true, :id => false do |t|
      t.column "tag_id", :integer
      t.column "project_id", :integer
    end
    
    create_table "sessions", :force => true do |t|
      t.column "session_id", :string
      t.column "data", :text
      t.column "updated_at", :datetime
    end

    add_index "sessions", ["session_id"], :name => "sessions_session_id_index"
  end

  def self.down
    drop_table :projects
    drop_table :assets
    drop_table :tags
    drop_table :tags_projects
    drop_table :tags_assets
    drop_table :sessions
    remove_index :sessions, "sessions_session_id_index"
  end
end
