class AddColumnProductProductItem < ActiveRecord::Migration
  def up
    add_column :product_product_items, :count, :integer ,:default => 0
  end

  def down
  end
end
