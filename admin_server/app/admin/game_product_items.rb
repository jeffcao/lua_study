#encoding:utf-8
ActiveAdmin.register GameProductItem do
  menu :if => proc{can? :manage,GameProductItem}
  menu :priority => 1, :label => proc{"index"}
  menu parent: "道具相关"
  #controller.authorize_resource
  
end
