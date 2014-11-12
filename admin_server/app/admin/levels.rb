#encoding:utf-8
ActiveAdmin.register Level do
  menu :if => proc{can? :manage,Level}
  menu :priority => 1, :label => proc{"index"}
  menu parent: "用户相关"
  #controller.authorize_resource
  
end
