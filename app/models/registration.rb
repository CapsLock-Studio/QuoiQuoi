class Registration < ActiveRecord::Base
  enum payment_method: {remittance: 0, paypal: 1, cvs_family: 2, cvs_ibon: 3, webatm: 4, atm: 5, alipay: 6, credit_card: 7}

  belongs_to :course
  belongs_to :user
  belongs_to :locale
  has_one :payment

  belongs_to :course_option

  has_many :user_gifts

  has_many :registration_options, dependent: :delete_all
  accepts_nested_attributes_for :registration_options

  has_one :registration_payment, dependent: :destroy

  def paid?
    self.payment
  end

  def tuition
    (self.course.course_translates.find_by_locale_id(self.locale_id).price + self.registration_options.map{|option| option.course_option.price}.sum) * self.attendance
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
