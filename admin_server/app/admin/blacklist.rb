#encoding: utf-8

ActiveAdmin.register Blacklist do
  menu :if => proc{can? :manage,AcceptMessageUser}

  menu parent: "游戏相关配置"


end
