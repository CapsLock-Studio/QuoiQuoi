class AddPopularToCourseAndRegistration < ActiveRecord::Migration
  def change
    add_column :courses, :popular, :integer
    add_column :registrations, :popular, :integer
  end
end
