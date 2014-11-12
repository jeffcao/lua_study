class AddColumnsToUserProducts < ActiveRecord::Migration
  def change
    add_column :user_products, :icon, :integer, :default => 0
    add_column :user_products, :product_sort, :integer, :default => 0
    add_column :user_products, :request_seq, :integer, :default => 0
  end
end
