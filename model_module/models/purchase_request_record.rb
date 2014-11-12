class PurchaseRequestRecord < ActiveRecord::Base
  attr_accessible :game_product_id, :operator_type, :product_count, :reason, :request_command,
                  :request_seq, :request_time, :request_type, :state, :user_id, :user_product_id,
                  :retry_times,:appid,:price, :real_amount,:server_flag
end
