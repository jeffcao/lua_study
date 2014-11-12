#encoding:utf-8
ActiveAdmin.register MarketCount do
  menu parent: "市场报表", url: '/admin/market_counts'
  config.clear_action_items!


  controller do
    def create
      index
    end

    def show
      index
    end

    def index
      unless params[:id].nil?
        #render :text=>"#{params[:id]}", :layout => 'active_admin'
        #return
        #@id = params[:id]
        cx_record = GetMobileChargeLog.where("id" => "#{params[:id]}").first
        unless cx_record.nil?

          cx_record.status = 1
          cx_record.update_attributes("operator" => current_super_user.email)
          cx_record.save
        end
      end
      @area = {}
      @status=["未充", "已充"]
      @year = params[:helperYear].nil? ? Time.now.strftime("%Y") : params[:helperYear]
      @month = params[:helperMonth].nil? ? Time.now.strftime("%m") : params[:helperMonth]
      @day = params[:helperDay].nil? ? Time.now.strftime("%d") : params[:helperDay]
      unless params[:date].nil?
        @year = params[:date][0, 4]
        @month = params[:date][5, 2]
        @day = params[:date][8, 2]
      end

      ch_date = "#{@year}-#{@month}-#{@day}"
      @records = []
      @date = ch_date.nil? ? Time.now.strftime("%Y-%m-%d") : ch_date
      @next_date = 1.day.since(@date.to_time).strftime("%Y-%m-%d")
      @records = GetMobileChargeLog.between(created_at: Date.parse(@date)..Date.parse(@next_date))
      unless @records.nil?
        @records.each do |area|
          msisdn = area.mobile
          msisdn_region = MsisdnRegion.find_by_id(msisdn[0..6].to_i)
          city_id = msisdn_region.city_id unless msisdn_region.nil?
          province_id = msisdn_region.province_id unless msisdn_region.nil?
          @area["#{msisdn}"] = "#{Provinces.find(province_id).name}#{City.find(city_id).name}" unless msisdn_region.nil?
        end
      end
      render 'view', :layout => 'active_admin'
      #render :text=>"#{@date}_#{@next_date}"
    end
  end

end
