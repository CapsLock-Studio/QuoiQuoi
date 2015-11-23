class CreateOrderRemittanceReports < ActiveRecord::Migration
  def change
    create_table :order_remittance_reports do |t|
      t.float :amount
      t.integer :account
      t.datetime :date
      t.boolean :confirm, default: false
      t.references :order_payment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
