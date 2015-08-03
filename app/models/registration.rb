class Registration < ActiveRecord::Base
  enum payment_method: {remittance: 0, paypal: 1, cvs_family: 2, cvs_ibon: 3, webatm: 4, atm: 5, alipay: 6}

  belongs_to :course
  belongs_to :user
  has_one :payment

  belongs_to :course_option

  has_many :user_gifts

  has_many :registration_options
  accepts_nested_attributes_for :registration_options

  has_one :registration_payment

  def paid?
    self.payment
  end

  def tuition
    (self.course.course_translate.price + self.registration_options.map{|option| option.course_option.price}.sum) * self.attendance
  end

  # Force input value convert to integer
  def payment_method=(value)
    write_attribute(:payment_method, (value.is_a?(Integer))? value : value.to_i)
  end

  def has_expire_time?
    (self.remittance? || self.cvs_family? || self.cvs_ibon? || self.atm?) &&
        (!self.registration_payment.expire_time.nil?)
  end

  def empty_expire_time?
    (self.remittance? || self.cvs_family? || self.cvs_ibon? || self.atm?) &&
        (self.registration_payment.expire_time.nil?)
  end
end
