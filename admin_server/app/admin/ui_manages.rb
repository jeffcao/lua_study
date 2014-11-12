#encoding: utf-8
ActiveAdmin.register UiManage do
  #menu parent: "游戏相关配置"

  menu :if => proc{can? :manage,UiManage}
  menu parent: "游戏相关配置"

  #controller.authorize_resource
  
end
