require File.expand_path("../../../lib/game_activity_effect/activity_effect.rb", __FILE__)

class Activity < ActiveRecord::Base
  attr_accessible :activity_content, :activity_memo, :activity_model, :activity_name, :activity_object, :activity_parm, :activity_type, :week_date

  after_initialize :init

  def init
    if self.activity_model.blank?
      self.instance_eval "extend UnknownEffect"
    else
      self.instance_eval "extend #{self.activity_model}"
    end

  end
  def feature
    if  self.activity_parm.blank?
      {}
    else
      JSON.parse(self.activity_parm)
    end
  end

end
