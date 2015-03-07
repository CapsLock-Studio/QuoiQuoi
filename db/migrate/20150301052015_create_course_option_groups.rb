class CreateCourseOptionGroups < ActiveRecord::Migration
  def change
    create_table :course_option_groups do |t|
      t.references :course, index: true
      t.references :locale, index: true
      t.string :name

      t.timestamps
    end
  end
end
