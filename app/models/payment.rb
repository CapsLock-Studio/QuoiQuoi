class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  belongs_to :registration
  belongs_to :user_gift

  validates :token, uniqueness: true
  validates :amount, presence: true
  attr_reader :redirect_uri

  def setup!(amount, currency, success_uri, cancel_uri)
    response = client.setup(
        payment_request(amount, currency),
        success_uri,
        cancel_uri,
        pay_on_paypal: true,
        no_shipping: true
    )
    self.amount = amount
    self.token = response.token

    self.save!

    #return redirect_uri
    @redirect_uri = response.redirect_uri

    # return Payment object
    self
  end

  def cancel!
    self.canceled = true
    self.save!

    # return Payment object
    self
  end

  def unsubscribe!
    client.renew!(self.identifier, :Cancel)
    self.cancel!
  end

  def complete!(payer_id = nil)
    response = client.checkout!(self.token, payer_id, payment_request(self.amount, self.currency))
    self.payer_id = payer_id
    self.identifier = response.payment_info.first.transaction_id

    self.completed = true
    self.pay_time = Time.now
    self.save!

    # return Payment object
    self
  end

  def remitted?
    flag = false
    if self.wait? && !self.amount.blank? && !self.completed?
      flag = true
    end

    flag
  end

  def payment_request(amount, currency)
    if amount > 0
      Paypal::Payment::Request.new(
          currency_code: currency,
          description: '布知道(QuoiQuoi)工作室',
          quantity: 1,
          amount: amount
      )
    else
      self.cancel!
    end
  end

  def client
    Paypal::Express::Request.new PAYPAL_CONFIG
  end
end
