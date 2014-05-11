class Locale < ActiveRecord::Base
  validates :lang, presence: true
  validates :name, presence: true

  has_many :product_translates
  accepts_nested_attributes_for :product_translates, allow_destroy: true
  has_many :material_translates
  has_many :designer_translates
  accepts_nested_attributes_for :designer_translates, allow_destroy: true
  has_many :course_translates
  accepts_nested_attributes_for :course_translates, allow_destroy: true
  has_many :rent_intro_translates
  accepts_nested_attributes_for :rent_intro_translates, allow_destroy: true
end