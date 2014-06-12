class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :course, show: true
      t.references :user, show: true
      t.boolean :accept

      t.timestamps
    end
  end
end
