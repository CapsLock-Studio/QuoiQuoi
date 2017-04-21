# encoding: utf-8
namespace :order do
  desc 'Complete the order which is shipped -- Deprecated code'
  task close: :environment do
    Order.where(delivered: true).where('delivered_time < ?', 7.days.ago).update_all({closed: true, closed_time: Time.now})
  end

  desc 'Complete the order which is shipped'
  task archive: :environment do
    Order.where(delivered: true, closed: false).each do |order|

      if order.delivery_report?
        if order.delivery_report_handled?
          if ((Time.now - order.delivery_report_handled_time) / 1.days).to_i >= 30
            order.update({closed: true, closed_time: Time.now})
          end
        end
      else
        if ((Time.now - order.delivered_time) / 1.days).to_i >= 30
          order.update({closed: true, closed_time: Time.now})
        end
      end
    end
  end
end