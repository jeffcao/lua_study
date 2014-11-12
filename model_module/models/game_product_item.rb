require File.expand_path("../../../lib/game_prop_effect/prop_effect", __FILE__)
require File.expand_path("../../../lib/game_prop_effect/voice_effect", __FILE__)

class GameProductItem < ActiveRecord::Base

attr_accessible :beans, :cate_module, :game_id, :game_product_id, :item_feature, :item_name, :item_note, :using_point,:icon,:item_sort,:item_type

after_initialize :init

  def init
    if self.cate_module.blank?
      self.instance_eval "extend UnknownEffect"
    else
      self.instance_eval "extend #{self.cate_module}"
    end

  end
  def feature
    if  self.item_feature.blank?
      {}
    else
      JSON.parse(self.item_feature)
    end
  end
end
