class AddCloumnToHuoYueUser < ActiveRecord::Migration
  def change
    add_column :huo_yue_users,:hour_total,:integer
  end
end
