#encoding: utf-8

ActiveAdmin.register AcceptMessageUser do

  menu :if => proc{can? :manage,AcceptMessageUser}
  menu parent: "游戏相关配置"

  #controller.authorize_resource
  
end
