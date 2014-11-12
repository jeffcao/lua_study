class Addcolumntoddzpartner < ActiveRecord::Migration
  def up
    add_column :ddz_partners, :sms_content, :string
  end

  def down
  end
end
