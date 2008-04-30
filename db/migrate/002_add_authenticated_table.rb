class AddAuthenticatedTable < ActiveRecord::Migration
  # modify the table name for now, until I can figure out how to set it w/ the generator
  def self.up
    create_table "users", :force => true do |t|
      t.column "name",            :string, :limit => 100
      t.column "company",            :string, :limit => 100
      t.column "website",            :string
      t.column "login",            :string, :limit => 40
      t.column "email",            :string, :limit => 100
      t.column "crypted_password", :string, :limit => 40
      t.column "salt",             :string, :limit => 40
      #t.column "activation_code",  :string, :limit => 40 # only if you want
      #t.column "activated_at",     :datetime             # user activation
      t.column "created_at",       :datetime
      t.column "updated_at",       :datetime
      t.column "description",       :text
    end
  end

  def self.down
    drop_table "users"
  end
end
