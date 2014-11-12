#encoding:utf-8
ActiveAdmin.register KefuPayMobile do
  menu parent: "市场报表", url: '/admin/kefu_pay_mobiles'

  config.clear_action_items!

  index do
    column "电话", :mobile do |record|
      record.mobile
    end
    column "归属地", :mobile do |record|

      msisdn = record.mobile.to_s
      msisdn[0..6]
      msisdn_region = MsisdnRegion.find_by_id(msisdn[0..6].to_i)
      city_id = msisdn_region.city_id unless msisdn_region.nil?
      province_id = msisdn_region.province_id unless msisdn_region.nil?
      "#{Provinces.find(province_id).name}#{City.find(city_id).name}"

    end

    column "充值方式", :pay_type do |record|
      pay_fangshi = ["淘宝", "网银", "电信网站", "移动网站", "联通网站", "充值卡"]
      key = record.pay_type.to_i
      pay_fangshi[key]
    end

    column "状态",:status do |record|
      status = ["已冲","未冲"]
      key = record.status.to_i
      status[key]
    end

    column "未充值理由",:cause do |record|
      record.cause
    end

    column "附件地址",:picture_path do |record|
      record.picture_path

      link_to "#{request.protocol}#{request.host_with_port}#{record.picture_path}","#{request.protocol}#{request.host_with_port}#{record.picture_path}"

    end

  end

end
