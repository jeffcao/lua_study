#encoding:utf-8
ActiveAdmin.register UserScoreList do
  menu :priority => 1, :label => proc{"index"}
  menu parent: "用户相关"
  config.clear_action_items!
end
