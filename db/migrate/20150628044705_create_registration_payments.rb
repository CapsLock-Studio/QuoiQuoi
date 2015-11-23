class CreateRegistrationPayments < ActiveRecord::Migration
  def change
    create_table :registration_payments do |t|
      t.float :amount
      t.string :token
      t.string :bankcode
      t.string :account
      t.datetime :expire_time
      t.string :trade_no
      t.string :trade_time
      t.string :payment_no
      t.boolean :completed
      t.datetime :completed_time
      t.string :redirect_uri
      t.boolean :cancel, default: false
      t.text :cancel_reason
      t.datetime :cancel_time
      t.string :payer_id
      t.datetime :payment_time
      t.references :registration, index: true

      t.timestamps null: false
    end
  end
end
