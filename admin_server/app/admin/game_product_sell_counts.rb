#encoding:utf-8

ActiveAdmin.register GameProductSellCount do
  menu :if => proc{can? :manage,GameProductSellCount}
  menu :priority => 1, :label => proc{"index"}
  menu parent: "道具相关"
  #controller.authorize_resource
  index do
    column :id
    column :game_product_id
    column :name do |item|
      begin
       GameProduct.find(item.game_product_id).product_name unless GameProduct.find(item.game_product_id).nil?
      rescue
        ""
      end
    end
    column :sell_count
    default_actions
  end
  
end
