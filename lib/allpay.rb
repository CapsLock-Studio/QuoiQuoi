require 'allpay/helper'

module AllPay
  mattr_accessor :service_url
  mattr_accessor :merchant_id
  mattr_accessor :hash_key
  mattr_accessor :hash_iv
  mattr_accessor :return_url
  mattr_accessor :choose_payment

  def self.service_url
    # Only in production use the regular url.
    if Rails.env.production?
      'https://payment.allpay.com.tw/Cashier/AioCheckOut'
    else
      'http://payment-stage.allpay.com.tw/Cashier/AioCheckOut'
    end
  end

  def self.setup
    yield(self)
  end
end