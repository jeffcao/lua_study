ActiveAdmin.register EveryHourHuoYueUser do
  config.clear_action_items!
  controller do
    def index
      @date = params[:date]
      @date = Time.now.strftime("%Y-%m") if @date.nil?
      @records = HuoYueUser.where("date like '#{@date}%'").order("date desc")
      @data = {}
      date_records = HuoYueUser.find_by_sql("select distinct(substring(date,1,7)) as date from huo_yue_users order by date desc ")
      @q_date = []
      date_records.each do |date|
        @q_date.push(date["date"])
      end
      @bl_date=[]

      @records.each do |r|
        @bl_date.push(r.date) unless @bl_date.include?(r.date)
        key = "#{r.date}-#{r.hour}"
        @data["#{key}-count_1"] = r.count_1
        @data["#{key}-count_2"] = r.count_2
        @data["#{key}-count_3"] = r.count_3
        @data["#{key}-count_4"] = r.count_4
      end

      render "index", :layout => 'active_admin'



    end
  end

end