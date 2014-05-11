class AddAttendanceToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :attendance, :integer
    rename_column :registrations, :popular, :attendance
  end
end
