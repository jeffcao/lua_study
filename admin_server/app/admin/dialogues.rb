#encoding: utf-8

ActiveAdmin.register Dialogue do

  menu :if => proc{can? :manage,Dialogue}
  menu parent: "游戏相关配置"

  #controller.authorize_resource
  
end
