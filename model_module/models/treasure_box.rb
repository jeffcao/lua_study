class TreasureBox < ActiveRecord::Base
  attr_accessible :beans, :give_beans, :name, :note, :price, :sale_count, :sale_limit
end
