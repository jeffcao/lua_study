#encoding:utf-8
ActiveAdmin.register UserChangeMobile do
  menu parent: "市场报表", url: '/admin/user_change_mobiles'

  config.clear_action_items!
  controller do
    def index
      @date = 1.day.since(Time.now).strftime("%Y-%m-%d").to_s
      @begin_date = 7.days.ago(Time.now).strftime("%Y-%m-%d").to_s
      records = GetMobileChargeLog.between(created_at: Date.parse(@begin_date)..Date.parse(@date))
      @content = {}
      unless records.nil?
        records.each do |r|
          key =r.created_at.to_s[0,10]
          @content["#{key}-count_fee_0"] = @content["#{key}-count_fee_0"].to_i + r.fee.to_i if r.status.to_i ==0
          @content["#{key}-count_fee_1"] = @content["#{key}-count_fee_1"].to_i + r.fee.to_i if r.status.to_i ==1
          @content["#{key}-count_0"] = @content["#{key}-count_0"].to_i + 1 if r.status.to_i ==0
          @content["#{key}-count_1"] = @content["#{key}-count_1"].to_i + 1 if r.status.to_i ==1
        end
      end

      render 'index', :layout => 'active_admin'

    end

  end

end