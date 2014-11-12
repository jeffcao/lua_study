#encoding:utf-8

ActiveAdmin.register PartnerBaobiao do
  menu parent: "市场报表", url: '/admin/partner_baobiaos'

  config.clear_action_items!
  controller do
    def index
      @partner_msg = {}
      all_panters = Partmer.all
      all_panters.each do |cp|
        @partner_msg["#{cp.partner_appid}"] = "#{cp.partner_appid}:#{cp.partner_name}"
      end
      @partner = params[:partner]
      email =current_super_user.email
      @role = current_super_user.role
      partner = Partmer.find_by_email(email)
      appid =partner.partner_appid unless partner.nil?
      Rails.logger.debug("PartnerBaobiao.appid=>#{appid}")

      @begin_day = params["begin_day"].nil? ? "01":params["begin_day"]
      @end_day = params["end_day"].nil? ? Time.now.strftime("%d"):params["end_day"]
      @select_date = @records=[]
      @date = params["date"].nil? ? Time.now.strftime("%Y-%m"):params["date"]
      date = params["date"].nil? ? Time.now.strftime("%Y-%m"):params["date"]

      if @role!="cp"
        appid = @partner unless @partner.nil?
      end
      appid = 1000 if appid.nil?

      unless appid.nil?
        @select_date = PartnerSheet.find_by_sql("select distinct(substring(date,1,7)) as date from partner_sheets order by date desc")
        begin_date = date.to_s + "-#{@begin_day}"
        end_date = date.to_s + "-#{@end_day}"
        #@records = PartnerSheet.find_by_sql("select date,total_users_count,appid,add_count,login_count,consume_count from partner_sheets where appid ='#{appid}' and date like '#{date}%' order by date desc")
        Rails.logger.debug("PartnerBaobiao.select date,total_users_count,appid,add_count,login_count,consume_count from partner_sheets where appid ='#{appid}' and date>='#{begin_date}' and date<='#{end_date}' order by date desc")
        @records = PartnerSheet.find_by_sql("select date,total_users_count,appid,add_count,login_count,consume_count,one_day_left_user,three_day_left_user,seven_day_left_user,one_day_left_user_rate,three_day_left_user_rate,seven_day_left_user_rate from partner_sheets where appid ='#{appid}' and date>='#{begin_date}' and date<='#{end_date}' order by date desc")

      end
      @month_account = PartnerMonthAccount.find_by_appid_and_date(appid,date)
      render 'index', :layout => 'active_admin'

    end
    def new
      index
    end
  end

end
