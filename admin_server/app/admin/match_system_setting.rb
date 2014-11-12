#encoding:utf-8
ActiveAdmin.register MatchSystemSetting do
  menu parent: "市场报表", url: '/admin/match_system_settings'
  # menu :priority => 1, :label => proc{"index"}
  config.clear_action_items!

end