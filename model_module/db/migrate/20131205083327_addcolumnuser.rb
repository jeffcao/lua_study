class Addcolumnuser < ActiveRecord::Migration
  def up
    add_column :users,:prize,:integer,:default => 0
  end

  def down
  end
end
