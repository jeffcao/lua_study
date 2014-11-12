#encoding: utf-8
require 'iconv'
class PropController < ApplicationController
  def prop_list
    props = GameProduct.all
    result = []
    props.each do |prop|
      tmp_prop = {}
      #Iconv.iconv("utf-8","unicode","\u9ed1\u94c1\u5b9d\u7bb1")
      #tmp_prop = {:id => prop.reload(:lock => true).id, :name => prop.reload(:lock => true).product_name, :price => prop.reload(:lock => true).price}
      tmp_prop = {:id => prop.reload(:lock => true).id, :name =>prop.reload(:lock => true).product_name, :price => prop.reload(:lock => true).price}

      result.push(tmp_prop)

    end

    render :json => result.to_json
  end

  
  def enable_consume_code
    appid = params[:appid]
    product_id = params[:product_id]
    enable = params[:enable]
    if appid.nil? or enable.nil?
      render :text => "false"
      return
    end

    if product_id.nil? or product_id.size<1
      DdzPartner.where(["appid=?", appid]).update_all(:enable => enable)
    else
      record = DdzPartner.find_by_appid_and_product_id(appid, product_id)
      if record.nil?
        render :text => "record is nil"
        return
      end

      record.enable = enable
      record.save
    end
    render :text => "OK"

  end


  
end




