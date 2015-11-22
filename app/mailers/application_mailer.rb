class ApplicationMailer < ActionMailer::Base
  # include Resque::Mailer
  default from: 'admin@quoiquoi.tw'
  layout 'mailer'

  before_action :set_locale_id

  private
  def set_locale_id
    @locale_id = Locale.find_by_lang('zh-TW').id
  end
end