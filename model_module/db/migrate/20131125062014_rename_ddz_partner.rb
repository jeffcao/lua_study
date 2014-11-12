class RenameDdzPartner < ActiveRecord::Migration
  def up
    rename_column :ddz_partners, :consume_code, :product_id
  end

  def down
  end
end
