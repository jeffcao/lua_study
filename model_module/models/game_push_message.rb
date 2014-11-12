class GamePushMessage
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  field :type, type: Integer
  field :content, type: String
  field :editor, type: String
  field :level, type: String
  field :position, type: String
  field :auditor, type: String
  field :advice, type: String
  field :p_time, type: String
  field :edit_time,type: DateTime
  field :audit_time,type: DateTime
  field :tuisong,type: String
end