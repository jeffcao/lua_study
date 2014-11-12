#encoding:utf-8
ActiveAdmin.register UserMobileList do
  menu parent: "市场报表", url: '/admin/user_mobile_lists?order=position_asc'
  config.clear_action_items!

  def scoped_collection
    UserMobileList.order_by("position asc")
    #UserMobileList.first
  end

  index do
    column  :user_id do |user|
      @user = User.find(user.user_id)
      user.user_id
    end
    column  :nick_name do |user|
      User.find(user.user_id).user_profile.nick_name
    end
    column  :msisdn do  |user|
      #User.find(user.user_id).user_profile.msisdn
      @user = User.find(user.user_id)
      record=GetMobileChargeLog.where("user_id"=>@user.user_id).first
      mobile = record.nil? ? "":record.mobile
      mobile
      #User.find(user.user_id).user_profile.user_id
    end
    column  :total_balance do |user|
      User.find(user.user_id).user_profile.total_balance.to_i
    end
    column  :balance do |user|
      get_mobile = User.find(user.user_id).user_profile.total_balance.to_i-User.find(user.user_id).user_profile.balance.to_i
      get_mobile
    end
    column  :position
    column  :city do |user|
      @user = User.find(user.user_id)
      record=GetMobileChargeLog.where("user_id"=>@user.user_id).first
      mobile = record.nil? ? "":record.mobile.to_s
      mobile
      if mobile.length >10
        msisdn_region = MsisdnRegion.find_by_id(mobile[0..6].to_i)
        city_id = msisdn_region.city_id
        province_id = msisdn_region.province_id
        area = "#{Provinces.find(province_id).name}#{City.find(city_id).name}"
      else
        area =""
      end
      area
    end
  end

end
