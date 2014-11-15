class CreateCourseAdditionImages < ActiveRecord::Migration
  def change
    create_table :course_addition_images do |t|
      t.references :course, index: true
      t.attachment :image

      t.timestamps
    end
  end
end
