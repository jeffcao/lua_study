#encoding:utf-8
ActiveAdmin.register DdzBaobiao do
  config.clear_action_items!
  controller do
    def index
      @total = DdzSheet.find_by_sql("select sum(total_day_money) as total_shouru,max(total_exp_user) as total_user from ddz_sheets")
      @q_date = []

      @select_date = DdzSheet.find_by_sql("select distinct(substring(date,1,7)) as date from ddz_sheets order by date desc")
      @select_date.each do |i|
        @q_date.push(i["date"])
      end
      @user_count = User.where("robot=? and user_id >?  and created_at < ?", 0, 49999,  Time.now.strftime("%Y-%m-%d")).count

      @result = []
      @data = {}
      @date = Time.now.strftime("%Y-%m")
      @date = params["date"].nil? ? @date : params["date"]
      day = Time.now.strftime("%d")
      sql = "select date,day_max_online,avg_hour_online,day_login_user,total_user,add_day_user,total_exp_user,day_exp_user,add_exp_user,total_day_money,arpu,platform from ddz_sheets "
      ## where created_at like '#{date}%'
      unless params["day"].nil?
        date = date + "-#{params["day"]}"
        sql = sql + " where date = #{date}"
      else
        sql = sql + " where date like '#{@date}%'"
      end
      sql = sql + " order by date desc"
      @sql = sql
      @result = DdzSheet.find_by_sql(sql)
      total_exp_user = total_new_user = total_online_user = 0
      @ddz_month_account = User.where("created_at like '#{@date[0, 7]}%'").count
      @result.delete_at(0) if @date == Time.now.strftime("%Y-%m").to_s
      login_table = "login_logs_#{@date[0, 7].gsub("-", "")}"
      huoyue_record = DdzSheet.where("date<'#{Time.now.strftime("%Y-%m-%d")}' and date like '#{@date[0, 7]}%'")
      #@month_huoyue_count = DdzSheet.find_by_sql("select sum(day_login_user) as sum from ddz_sheets where date like '#{@date[0, 7]}%'")
      #@month_huoyue_count = @month_huoyue_count.first["sum"] unless @month_huoyue_count.nil?
      @month_huoyue_count = 0
      if @date[0, 7] < Time.now.strftime("%Y-%m").to_s
        all_sql = "select sum(day_login_user) as sum from ddz_sheets where substring(date,1,7)<='#{@date[0, 7] }'"
      else
        all_sql = "select sum(day_login_user) as sum from ddz_sheets where date<'#{Time.now.strftime("%Y-%m-%d") }'"
      end
      @all_huoyue_count = DdzSheet.find_by_sql(all_sql)
      @all_huoyue_count = @all_huoyue_count.first["sum"] unless @all_huoyue_count.nil?
      #@month_chongzhi_user = PurchaseRequestRecord.find_by_sql("select count(distinct(user_id)) as sum from purchase_request_records where state=1 and created_at like '#{@date[0, 7]}%'")
      #@month_total_shouru = PurchaseRequestRecord.find_by_sql("select sum(price) as sum from purchase_request_records where state=1 and created_at like '#{@date[0, 7]}%'")
      #@month_chongzhi_user = @month_chongzhi_user.first["sum"] unless @month_chongzhi_user.nil?
      @month_chongzhi_user =@month_total_shouru= 0
      #@month_total_shouru = @month_total_shouru.first["sum"]/100 unless @month_total_shouru.nil?
      #@month_add_count = User.where("user_id >50000 and user_id<90000 and created_at like '#{@date[0, 7]}%'").count
      @month_add_count = 0
      @user_count = User.where("user_id >50000  and substring(created_at,1,7) <= '#{@date}'").count if @date[0, 7] < Time.now.strftime("%Y-%m").to_s
      @user_count = User.where("user_id >50000  and created_at <'#{Time.now.strftime("%Y-%m-%d")}'").count if @date[0, 7] == Time.now.strftime("%Y-%m").to_s

      if @date < Time.now.strftime("%Y-%m").to_s
        all_sql = "select count(distinct(user_id)) as sum from purchase_request_records where state=1 and substring(created_at,1,7)<='#{@date[0, 7]}'"
      else
        all_sql = "select count(distinct(user_id)) as sum from purchase_request_records where state=1 and substring(created_at,1,10)<='#{Time.now.strftime("%Y-%m-%d")}'"
      end
      @all_chongzhi_yonghu = PurchaseRequestRecord.find_by_sql(all_sql)
      @all_chongzhi_yonghu = @all_chongzhi_yonghu.first["sum"] unless @all_chongzhi_yonghu.nil?
      if @date[0, 7] < Time.now.strftime("%Y-%m").to_s
        all_sql = "select sum(total_day_money) as sum from ddz_sheets where  substring(date,1,7)<='#{@date}'"
      else
        all_sql = "select sum(total_day_money) as sum from ddz_sheets where  date<'#{Time.now.strftime("%Y-%m-%d")}'"
      end

      @all_chongzhi_shouru = DdzSheet.find_by_sql(all_sql)
      @all_chongzhi_shouru = @all_chongzhi_shouru.first["sum"] unless @all_chongzhi_shouru.nil?
      @all_chongzhi_shouru = @all_chongzhi_shouru.to_i
      huoyue_record.each do |num|
        @data["#{num.date.to_s[8, 2]}-huoyue_yonghu"] = num.day_login_user
        @month_huoyue_count = @month_huoyue_count.to_i + num.day_login_user.to_i
      end

      @result.each do |record|
        key = record["date"][8, 2]
        @month_add_count = @month_add_count + (record["add_day_user"] || 0)
        @data["#{key}-day_max_online"] = (record["day_max_online"] || 0)
        @data["#{key}-avg_hour_online"] = (record["avg_hour_online"] || 0)
        @data["#{key}-day_login_user"] = (record["day_login_user"] || 0)
        @data["#{key}-add_day_user"] = (record["add_day_user"] || 0)
        @data["#{key}-total_exp_user"] = (record["total_exp_user"] || 0)
        @data["#{key}-day_exp_user"] = (record["day_exp_user"] || 0)
        @month_chongzhi_user = @month_chongzhi_user + (record["day_exp_user"] || 0)
        @month_total_shouru = @month_total_shouru + (record["total_day_money"] || 0)
        @data["#{key}-add_exp_user"] = (record["add_exp_user"] || 0)
        @data["#{key}-total_day_money"] = (record["total_day_money"] || 0)
        @data["#{key}-total_user"] = (record["total_user"] || 0)
        unless record["total_day_money"].nil?

          @data["#{key}-erpu"] = (record["total_day_money"]/record["day_exp_user"]) unless record["day_exp_user"].nil?
          @data["#{key}-erpu"] = 0 if record["day_exp_user"].nil? or record["day_exp_user"].to_i ==0
        else
          @data["#{key}-erpu"] = 0
        end
        total_exp_user = total_exp_user.to_i + record["add_exp_user"].to_i
        total_new_user = total_new_user.to_i + record["add_day_user"].to_i
        total_online_user = total_online_user.to_i + record["avg_hour_online"].to_i

      end
      day = Time.now.strftime("%d").to_i - 1
      day = 1 if day==0
      @avg_add_user = (total_new_user/day).to_i
      @avg_online_user = (total_online_user/day).to_i
      @avg_exp_user = (total_exp_user/day).to_i


      render 'index', :layout => 'active_admin'
    end
  end

end