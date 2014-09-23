class SetDefaultToCourseOptions < ActiveRecord::Migration
  def change
    change_column :course_options, :price, :float, default: 0
  end
end
