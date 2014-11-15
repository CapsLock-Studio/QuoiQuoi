class PastWorkType < ActiveRecord::Base
  has_many :past_works
  has_many :past_work_type_translates
  accepts_nested_attributes_for :past_work_type_translates

  has_one :past_work_type_translate

  # thumbnail in type list page
  has_attached_file :thumbnail, styles: {'300x225' => '300x225#', medium: '300x225#'}, default_url: 'http://placehold.it/:style'
  validates_attachment_content_type :thumbnail, content_type: /\Aimage\/.*\Z/

  # hero image in page header in list page
  has_attached_file :image, styles: {'960x260' => '960x260#', large: '960x260#'}, default_url: 'http://placehold.it/:style'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
