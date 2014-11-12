class UserId < ActiveRecord::Base
  attr_accessible :next_id
  def self.generate_next_id
    user_id = UserId.first
    current_id = 0
    user_id.with_lock  do
      while current_id <= 0
        current_id = user_id.next_id
        user_id.next_id = user_id.next_id + 1
      end
      user_id.save
      current_id
    end
  end
end
