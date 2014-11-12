class AddColumnToUserProduct < ActiveRecord::Migration
  def change
    add_column :user_products, :price, :string
    add_column :user_products, :sale_limit, :integer
    add_column :user_products, :state, :integer
  end
end
