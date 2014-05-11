class CreateRemittances < ActiveRecord::Migration
  def change
    create_table :remittances do |t|

      t.timestamps
    end
  end
end
