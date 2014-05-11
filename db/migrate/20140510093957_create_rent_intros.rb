class CreateRentIntros < ActiveRecord::Migration
  def change
    create_table :rent_intros do |t|
      t.attachment :image

      t.timestamps
    end
  end
end
