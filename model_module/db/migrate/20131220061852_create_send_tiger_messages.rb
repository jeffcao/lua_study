class CreateSendTigerMessages < ActiveRecord::Migration
  def change
    create_table :send_tiger_messages do |t|

      t.timestamps
    end
  end
end
