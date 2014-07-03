class CreateCourseOptions < ActiveRecord::Migration
  def change
    create_table :course_options do |t|
      t.references :course, index: true
      t.references :locale, index: true
      t.string :content

      t.timestamps
    end
  end
end
