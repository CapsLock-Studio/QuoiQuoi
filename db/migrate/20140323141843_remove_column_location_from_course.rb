class RemoveColumnLocationFromCourse < ActiveRecord::Migration
  def change
    remove_column :course_translates, :location
  end
end
