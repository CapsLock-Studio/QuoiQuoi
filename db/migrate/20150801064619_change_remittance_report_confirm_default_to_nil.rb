class ChangeRemittanceReportConfirmDefaultToNil < ActiveRecord::Migration
  def change
    change_column_default :order_remittance_reports, :confirm, nil
    change_column_default :registration_remittance_reports, :confirm, nil
  end
end
