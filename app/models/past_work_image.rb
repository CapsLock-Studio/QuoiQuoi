class PastWorkImage < ActiveRecord::Base
  default_scope ->() {order(:id)}

  belongs_to :past_work

  has_attached_file :image, styles: {thumb: '100', small: '300', medium: '500', large: '1000'}, default_url: '/system/placeholder/general.gif'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end