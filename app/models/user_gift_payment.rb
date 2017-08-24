class UserGiftPayment < ApplicationRecord
  belongs_to :user_gift

  has_many :user_gift_remittance_reports, dependent: :delete_all

  def remittance_reports_in_process?
    self.user_gift_remittance_reports.where(confirm: nil).size > 0
  end

  def has_valid_remittance_reports?
    self.user_gift_remittance_reports.size > 0
  end
end
