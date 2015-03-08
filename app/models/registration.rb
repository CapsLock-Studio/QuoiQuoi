class Registration < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_one :payment

  belongs_to :course_option

  has_many :user_gifts

  has_many :registration_options
  accepts_nested_attributes_for :registration_options

  def paid?
    self.payment
  end
end
