#encoding: utf-8

ActiveAdmin.register SystemSetting do
  menu :if => proc{can? :manage,SystemSetting}
  menu parent: "游戏相关配置"

  #controller.authorize_resource

  index do
    column :id
    column :setting_name
    column :setting_value, :setting_value do |object|
      object.setting_value.slice(0, 50)
    end
    column :description
    column :enabled
    column :flag

    default_actions
  end


end
