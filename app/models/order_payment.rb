class OrderPayment < ActiveRecord::Base
  belongs_to :order

  has_many :order_remittance_reports, dependent: :delete_all

  def remittance_reports_in_process?
    self.order_remittance_reports.where(confirm: nil).size > 0
  end

  def has_valid_remittance_reports?
    self.order_remittance_reports.size > 0
  end
end
