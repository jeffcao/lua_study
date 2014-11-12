class PropConsumeCode < ActiveRecord::Base
  belongs_to :game_product
  attr_accessible :game_product_id,:consume_code,:operator_type
end
