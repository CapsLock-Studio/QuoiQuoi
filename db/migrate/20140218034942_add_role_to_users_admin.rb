class AddRoleToUsersAdmin < ActiveRecord::Migration
  def change
    add_column :users, :role, :string
    add_column :admins, :role, :string
  end
end
