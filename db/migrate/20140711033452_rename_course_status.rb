class RenameCourseStatus < ActiveRecord::Migration
  def change
    rename_column :courses, :closed, :full
    rename_column :courses, :closed_time, :full_time
  end
end
