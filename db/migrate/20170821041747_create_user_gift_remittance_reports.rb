class CreateUserGiftRemittanceReports < ActiveRecord::Migration[5.0]
  def change
    create_table :user_gift_remittance_reports do |t|
      t.float :amount
      t.integer :account
      t.datetime :date
      t.boolean :confirm, default: false
      t.references :user_gift_payment, index: true, foreign_key: true

      t.timestamps
    end
  end
end
