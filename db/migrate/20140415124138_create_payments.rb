class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.string :token
      t.string :identifier
      t.references :user, index: true
      t.string :payer_id
      t.boolean :completed
      t.boolean :canceled

      t.timestamps
    end
  end
end
