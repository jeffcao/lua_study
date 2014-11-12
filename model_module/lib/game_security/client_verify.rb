require 'result_code'

class ClientVerify

  def self.verify_client(signature_name, signature_token, connection_id, clinet_app_id)
    Rails.logger.info("[verify_client_name]=>#{signature_name}")
    return true
    apk_p_k = ApkSignaturePublicKey.find_by_name(signature_name)
    if apk_p_k.nil?
      Rails.logger.info("[verify_client], ApkSignaturePublicKey is nil.")
      return false
    end

    signature_public_key = apk_p_k.public_key
    #signature_public_key="109438210549104321"
    r_key = "#{connection_id}_verify_key"
    verify_info = Redis.current.get(r_key)
    return false if verify_info.nil?

    v_array = [signature_name, signature_public_key, verify_info]


    v_str =  v_array.join('')
    v_signature_token = Digest::MD5.hexdigest(v_str)
    Rails.logger.info("[verify_client_v_signature_token]=>#{v_signature_token}")
    Rails.logger.info("[verify_client_signature_token]=>#{signature_token}")

    v_signature_token ==  signature_token

  end

  def self.produce_verify_info(connection_id)
    r_key = "#{connection_id}_verify_key"
    characteristic_code = produce_characteristic_code
    Redis.current.set(r_key, "#{characteristic_code}")
    Redis.current.expire(r_key, 60*2)
    characteristic_code
  end

  def self.produce_characteristic_code
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    new_pass = ""
    1.upto(30) { |i| new_pass << chars[rand(chars.size-1)] }
    new_pass
  end

  
end

