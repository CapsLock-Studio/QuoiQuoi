class Registration < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_one :payment

  def paid?
    self.payment
  end
end
