#encoding: utf-8

ActiveAdmin.register GameTeach do
  menu :if => proc{can? :manage,GameTeach}
  menu parent: "游戏相关配置"

  #controller.authorize_resource
  
end
