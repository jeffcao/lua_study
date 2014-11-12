#encoding:utf-8
ActiveAdmin.register UserSheet do
  menu :priority => 1, :label => proc{"index"}
  menu parent: "用户相关"
  index do
    column :id
    column :date
    column :online_time_count
    column :login_count
    column :paiju_time_count
    column :paiju_count
    column :paiju_break_count
    column :bank_broken_count
    column :created_at
    column :updated_at
    default_actions
  end
  
end
