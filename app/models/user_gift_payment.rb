class UserGiftPayment < ApplicationRecord
  belongs_to :user_gift

  has_many :user_gift_remittance_reports, dependent: :delete_all

  after_save :create_user_gift_serial

  def remittance_reports_in_process?
    self.user_gift_remittance_reports.where(confirm: nil).size > 0
  end

  def has_valid_remittance_reports?
    self.user_gift_remittance_reports.size > 0
  end

  def create_user_gift_serial
    if self.completed?
      exists_serial_count = self.user_gift.user_gift_serials.size
      (exists_serial_count...self.user_gift.quantity).each do
        self.user_gift.user_gift_serials.create({ serial: get_uniqueness_random_string })
      end
    end
  end

  private
  def get_uniqueness_random_string
    uniqueness_random_string = SecureRandom.hex(20)
    while UserGiftSerial.where(serial: uniqueness_random_string).first
      uniqueness_random_string = SecureRandom.hex(20)
    end

    uniqueness_random_string
  end
end
