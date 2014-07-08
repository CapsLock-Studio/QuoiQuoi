# encoding: utf-8
namespace :order do
  desc 'Complete the order which is shipped'
  task close: :environment do
    Order.where(delivered: true).where('delivered_time < ?', 7.days.ago).update_all({closed: true, closed_time: Time.now})
  end
end