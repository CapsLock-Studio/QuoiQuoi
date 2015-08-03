class RegistrationPayment < ActiveRecord::Base
  belongs_to :registration

  has_many :registration_remittance_reports

  def remittance_reports_in_process?
    self.registration_remittance_reports.where(confirm: nil).size > 0
  end

  def has_valid_remittance_reports?
    self.registration_remittance_reports.size > 0
  end
end
