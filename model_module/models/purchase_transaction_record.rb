class PurchaseTransactionRecord < ActiveRecord::Base
  attr_accessible :elapsed_time, :operator_user_id, :request_id, :request_ip, :request_message, :request_time, :request_url, :response_message, :response_time
end
