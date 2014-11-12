class ShareWeibo < ActiveRecord::Base
  attr_accessible :appkey, :ralate_uid, :title, :url, :weibo_type
end
