class ModifyColumnRecuritment < ActiveRecord::Migration
  def change
    change_column :requirement_translates, :description, :text
  end
end
