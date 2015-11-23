class CreateRegistrationRemittanceReports < ActiveRecord::Migration
  def change
    create_table :registration_remittance_reports do |t|
      t.float :amount
      t.integer :account
      t.datetime :date
      t.boolean :confirm
      t.references :registration_payment, foreign_key: true

      t.timestamps null: false
    end

    add_index :registration_remittance_reports, :registration_payment_id, name: 'index_registration_remittance_report_to_payment'
  end
end
