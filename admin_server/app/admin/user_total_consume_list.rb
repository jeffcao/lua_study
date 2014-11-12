#encoding:utf-8
ActiveAdmin.register UserTotalConsumeList do
  menu parent: "市场报表", url: 'user_total_consume_lists?order=rank_asc'
  config.clear_action_items!
  index do
    column :rank
    column :user_id
    column :nick_name
    column :total_consume
    column :total_balance
    column :get_balance
    column :mobile

  end
end
