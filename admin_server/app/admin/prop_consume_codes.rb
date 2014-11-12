#encoding:utf-8
ActiveAdmin.register PropConsumeCode do
  menu :if => proc{can? :manage,PropConsumeCode}
  menu :priority => 1, :label => proc{"index"}
  menu parent: "道具相关"
  #controller.authorize_resource

  index do
    column :id
    column :consume_code
    column :game_product_id
    column :created_at
    column :updated_at

    default_actions
  end

end
