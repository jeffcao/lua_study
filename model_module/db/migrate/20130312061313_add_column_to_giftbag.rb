class AddColumnToGiftbag < ActiveRecord::Migration
  def change
    add_column :gift_bags, :note, :string
  end
end
