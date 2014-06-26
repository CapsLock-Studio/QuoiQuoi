# encoding : utf-8
namespace :payment do
  desc 'Auto cancel over three day not remittance payment'
  task cancel: :environment do
    Payment.where(completed: false, pay_time: nil).where('created_at < ?', 3.days.ago).destroy_all
  end
end