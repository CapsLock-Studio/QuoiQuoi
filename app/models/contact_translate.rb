class ContactTranslate < ActiveRecord::Base
  belongs_to :contact
  belongs_to :locale
end
