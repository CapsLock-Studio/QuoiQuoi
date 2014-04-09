class SlideTranslate < ActiveRecord::Base
  belongs_to :locale
  belongs_to :slide
end
