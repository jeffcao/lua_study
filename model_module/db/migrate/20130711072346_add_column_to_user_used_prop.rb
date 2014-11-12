class AddColumnToUserUsedProp < ActiveRecord::Migration
  def change
    add_column  :user_used_props, :game_id, :integer, :default=>0
  end
end
