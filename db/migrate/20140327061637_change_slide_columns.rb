class ChangeSlideColumns < ActiveRecord::Migration
  def change
    add_column :slides, :position, :integer
    remove_column :slide_translates, :title
  end
end
