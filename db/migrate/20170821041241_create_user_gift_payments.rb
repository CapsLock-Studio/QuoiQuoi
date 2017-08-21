class CreateUserGiftPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :user_gift_payments do |t|
      t.float :amount
      t.string :token
      t.string :bankcode
      t.string :account
      t.datetime :expire_time
      t.string :trade_no
      t.datetime :trade_time
      t.string :payment_no
      t.boolean :completed
      t.datetime :completed_time
      t.string :redirect_uri

      t.timestamps null: false
    end
  end
end
