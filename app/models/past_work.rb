class PastWork < ActiveRecord::Base
  scope :destroy_empty, ->() {where(completion_time: nil).destroy_all}

  belongs_to :past_work_type

  has_one :past_work_translate

  has_many :past_work_translates
  accepts_nested_attributes_for :past_work_translates

  has_many :past_work_images
  accepts_nested_attributes_for :past_work_images, allow_destroy: true

  has_many :past_work_addition_images, dependent: :destroy
  accepts_nested_attributes_for :past_work_addition_images, allow_destroy: true

  has_attached_file :image, styles: {thumb: '100x75#', small: '300x225#', medium: '500x375#', large: '1000x750#'}, default_url: '/system/placeholder/:style.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  def others(locale_id, limit)
    PastWork.includes(:past_work_translate)
            .where(past_work_translates: {locale_id: locale_id},
                   past_work_type_id: self.past_work_type_id,
                   visible: true)
            .where.not(past_work_translates: {name: '', description: ''}, id: self.id)
            .order('past_works.id DESC, past_works.completion_time DESC').limit(limit)
  end
end