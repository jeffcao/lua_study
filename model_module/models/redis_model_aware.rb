module RedisModelAware

  extend ActiveSupport::Concern

  include BaseModelHelper

  #attr_accessor :redis_key_id
  attr_accessor :redis_key

  def reload_from_redis(key_id = nil)
    key_id ||= self.redis_key_id

    if key_id != redis_key_id or redis_key.blank?
      object_key = self.class.compute_key(key_id)
    else
      object_key = redis_key
    end

    hash_values = Redis.current.hgetall(object_key)
    return false if hash_values.empty?

    self.redis_key_id = key_id
    self.redis_key = object_key

    hash_values.each_pair do |key, value|
      self.instance_variable_set("@#{key}", value) if key != "__json_fields"
    end

    self.class.json_attributes.each do |attr|
      value = hash_values[attr]
      self.instance_variable_set("@#{attr}", (value.blank? || value =="null" || value == "nil") ? [] : JSON.parse(value) )
      self.instance_variable_set("@__#{attr}_original", (value.blank? || value =="null" || value == "nil") ? [] : JSON.parse(value) )
    end

    #unless hash_values["__json_fields"].blank?
    #  json_fields = hash_values["__json_fields"].to_s.split(",")
    #  json_fields.each do |field|
    #    self.instance_variable_set("@#{field}", JSON.parse(hash_values[field]) )
    #    self.instance_variable_set("@#{field}_original", JSON.parse(hash_values[field]) )
    #  end
    #end

    @previously_changes.clear if self.instance_variables.include?(:@previously_changes)
    @changed_attributes.clear if self.instance_variables.include?(:@changed_attributes)

    true
  end

  def save_to_redis(key_id = nil)
    key_id ||= redis_key_id

    if key_id != redis_key_id or redis_key.blank?
      object_key = self.class.compute_key(key_id)
    else
      object_key = redis_key
    end

    self.redis_key_id = key_id if self.redis_key_id != key_id
    self.redis_key = object_key if self.redis_key != object_key

    #return false unless self.changed?

    changed_data = {}

    array_fields = []
    changes_hash = self.changes
    changes_hash.each_pair do |field, values|
      if self.class.json_attributes.include?(field.to_s)
        changed_data[field] = values[1].to_json
      else
        changed_data[field] = values[1]
      end
    end

    self.class.json_attributes.each do |attr|
      #puts "checking #{attr}..."
      next if changes_hash.has_key?(attr)
      org_value = self.instance_variable_get("@__#{attr}_original")
      cur_value = self.send(attr)
      if org_value != cur_value
        if cur_value.blank?
          changed_data[attr] = nil
        else
          changed_data[attr] = cur_value.to_json
        end
      end
    end

    return false if changed_data.blank?

    #if array_fields.size > 0
    #  changed_data["__json_fields"] = array_fields.join(",")
    #end

    #p changed_data

    Redis.current.mapped_hmset(object_key, changed_data)

    #if array_data.size > 0
    #  array_data.each_pair do |field, value|
    #    array_key = [object_key, field].join(":")
    #    Redis.current.del(array_key)
    #    value.each do |v|
    #      Redis.current.lpush(array_key, v)
    #    end
    #  end
    #end

    true
  end

  def before_save
    save_to_redis
  end

  def remove_from_redis(key_id = nil)
    key_id ||= redis_key_id

    if key_id != redis_key_id or redis_key.blank?
      object_key = self.class.compute_key(key_id)
    else
      object_key = redis_key
    end

    Redis.current.del object_key
  end

  def expire(seconds)
    Redis.current.expire(self.redis_key, seconds)
  end

  def expire_at(at_time)
    Redis.current.expireat(self.redis_key, at_time)
  end

  module ClassMethods

    def compute_key(key_id)
      keys = []
      keys << self.redis_prefix if self.respond_to?(:redis_prefix)
      keys << self.to_s
      keys << key_id
      keys << self.redis_suffix if self.respond_to?(:redis_suffix)
      object_key = keys.join(":")

      object_key
    end

    def from_redis(key_id)
      new_object = self.new
      return new_object if new_object.reload_from_redis(key_id)

      nil
    end

    def remove_from_redis(key_id)
      object_key = self.compute_key(key_id)

      Redis.current.del object_key
    end


  end

end