class CreateBanWords < ActiveRecord::Migration
  def change
    create_table :ban_words do |t|
      t.string :word

      t.timestamps
    end
  end
end
