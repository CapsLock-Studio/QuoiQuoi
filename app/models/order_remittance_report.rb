class OrderRemittanceReport < ActiveRecord::Base
  belongs_to :order_payment

  def status
    status = 'denied'

    if self.confirm
      status = 'confirmed'
    elsif self.confirm.nil?
      status = 'waiting'
    end

    status
  end
end
