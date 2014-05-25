class ChangeColumnPropertiesToCourse < ActiveRecord::Migration
  def change
    change_column :course_translates, :description, :text
    change_column :product_translates, :description, :text
  end
end
