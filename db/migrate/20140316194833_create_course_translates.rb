class CreateCourseTranslates < ActiveRecord::Migration
  def change
    create_table :course_translates do |t|
      t.references :course, index: true
      t.references :locale, index: true
      t.string :name
      t.string :teacher
      t.string :description
      t.string :note
      t.string :location

      t.timestamps
    end
  end
end
