class OrderRemittanceReport < ActiveRecord::Base
  belongs_to :order_payment

  def status
    status = 'denied'

    if confirm.nil?
      status = 'waiting'
    elsif confirm
      status = 'confirmed'
    end

    status
  end

  def account
    if read_attribute(:account).blank?
      '無摺存款'
    else
      read_attribute(:account)
    end
  end
end
