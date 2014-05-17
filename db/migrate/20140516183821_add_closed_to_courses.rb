class AddClosedToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :closed, :boolean, default: false
    add_column :courses, :closed_time, :datetime
  end
end
