class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    add_column :users, :token_expire, :datetime
    add_column :users, :redirect_url, :string
  end
end
