ActiveAdmin.register HuoYueUserTuShi do
  config.clear_action_items!
  controller do
    def index
      @bl_date = []
      (1..7).each do |i|
         @bl_date.push(i.day.ago(Time.now).strftime("%Y-%m-%d")) if i==1
         @bl_date.push(i.days.ago(Time.now).strftime("%Y-%m-%d")) if i!=1
      end
      @date = params[:date]
      @date = 1.day.ago(Time.now).strftime("%Y-%m-%d") if @date.nil?
      @middle_date = 1.day.ago(@date.to_time).strftime("%Y-%m-%d")
      @last_date = 2.days.ago(@date.to_time).strftime("%Y-%m-%d")
      logger.debug("[HuoYueUserTuShi] last_date=>#{@last_date} date=>#{@date}")

      records = HuoYueUser.where("date between '#{@last_date}' and '#{@date}'").order("date desc,hour asc")
      @a =[]
      @b = []
      @c = []
      a_i = b_i = c_i = 0
      @max_data = 0
      records.each do |r|
        if r.date == @date
          @a.push([a_i,r.hour_total])
          a_i = a_i + 1
        elsif r.date == @last_date
          @c.push([c_i,r.hour_total])
          c_i = c_i + 1
        else
          @b.push([b_i,r.hour_total])
          b_i = b_i + 1
        end
        @max_data = @max_data > r.hour_total ? @max_data:r.hour_total
      end

      logger.debug("[HuoYueUserTuShi] @a=>#{@a} ")
      logger.debug("[HuoYueUserTuShi] @b=>#{@b} ")
      logger.debug("[HuoYueUserTuShi] @c=>#{@c} ")
      if @max_data%10 != 0
        key = @max_data/10
        key = key + 1
        @max_data = key*10
      end
      render "index", :layout => 'active_admin'

    end
    def create
      index
    end
  end







end