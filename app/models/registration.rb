class Registration < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_one :payment

  belongs_to :course_option

  has_many :user_gifts

  def paid?
    self.payment
  end
end
