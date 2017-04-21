class ContactTranslate < ApplicationRecord
  belongs_to :contact
  belongs_to :locale
end
