#encoding: utf-8

ActiveAdmin.register Activity do
  menu :if => proc{can? :manage,Activity}
  menu parent: "游戏相关配置"

  #controller.authorize_resource
  
end
