# encoding : utf-8
namespace :clean do
  desc 'Clean fragment data every day'
  task order_custom_item: :environment do
    OrderCustomItem.destroy_all(user_id: ['', nil])
  end
end