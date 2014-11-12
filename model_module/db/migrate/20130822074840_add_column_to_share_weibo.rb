class AddColumnToShareWeibo < ActiveRecord::Migration
  def change
    add_column :share_weibos, :weibo_type, :string
  end
end
