class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :price
      t.datetime :time
      t.integer :attendance

      t.timestamps
    end
  end
end
