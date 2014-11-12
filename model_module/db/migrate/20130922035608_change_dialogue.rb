class ChangeDialogue < ActiveRecord::Migration
  def up
    rename_column  :dialogues, :type, :vip_flag
  end

  def down
  end
end
