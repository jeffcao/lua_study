class KefuPayMobile < ActiveRecord::Base
  attr_accessible :cause, :mobile, :pay_type, :picture_path, :status
end
