class AddCancelToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :canceled, :boolean, default: false
    add_column :courses, :canceled_time, :datetime
    add_column :registrations, :returned, :boolean, default: false
    add_column :registrations, :returned_time, :datetime
  end
end
