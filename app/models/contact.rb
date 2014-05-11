class Contact < ActiveRecord::Base
  has_many :contact_translates, dependent: :destroy
  accepts_nested_attributes_for :contact_translates, allow_destroy: true
end
