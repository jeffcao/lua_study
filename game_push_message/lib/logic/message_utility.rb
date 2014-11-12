module MessageUtility

  extend ActiveSupport::Concern

  module ClassMethods
    def min_msg_seq
      seq_const = Time.now.strftime("%Y%m%d")
      seq_const.to_id + 1
    end

    def new_public_msg_seq
      key_const = "DDZ_PUBLIC_MSG_SEQ"
      new_msg_seq(key_const)
    end

    def new_device_msg_seq
      key_const = "DDZ_DEVICE_MSG_SEQ"
      new_msg_seq(key_const)
    end

    def new_msg_seq(key_const)
      seq_const = Time.now.strftime("%Y%m%d")
      key = "#{key_const}_#{seq_const}"
      MessageCounter.find_or_create_by(seq_key: key)
      seq_offset = MessageCounter.where(seq_key: key).find_and_modify({ "$inc"=>{seq_offset: 1} }, new: true )
      seq_const.to_i*1000 + seq_offset.seq_offset
    end
  end

end