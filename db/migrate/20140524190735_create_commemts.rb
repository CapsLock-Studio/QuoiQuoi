class CreateCommemts < ActiveRecord::Migration
  def change
    create_table :commemts do |t|
      t.string :name
      t.string :email
      t.string :messsage

      t.timestamps
    end
  end
end
