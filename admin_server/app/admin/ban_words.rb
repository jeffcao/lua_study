#encoding: utf-8

ActiveAdmin.register BanWord do
  menu :priority => 1, :label => proc{"index"}
  menu :if => proc{can? :manage,BanWord}
  menu parent: "游戏相关配置"

  #controller.load_resource
  #controller.load_and_authorize_resource
  #controller.authorize_resource
  #controller do
  #  load_and_authorize_resource
  #end


end
