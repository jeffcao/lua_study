class AddColumnToBanword < ActiveRecord::Migration
  def change
    add_column :ban_words, :zz_word, :string
  end
end
