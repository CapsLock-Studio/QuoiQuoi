class AddColumnLengthToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :length, :integer
  end
end
