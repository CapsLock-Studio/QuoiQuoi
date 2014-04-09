class RemoveColumnAttendanceFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :attendance
  end
end
