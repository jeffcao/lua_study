#encoding:utf-8
ActiveAdmin.register GameProduct do
  menu :if => proc{can? :manage,GameProduct}
  menu :priority => 1, :label => proc{"index"}
  menu parent: "道具相关"
  #controller.authorize_resource
end
