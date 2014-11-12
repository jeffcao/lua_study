#encoding:utf-8

ActiveAdmin.register GameMatch do
  menu :priority => 1, :label => proc{"index"}
  menu parent: "比赛相关"
end
