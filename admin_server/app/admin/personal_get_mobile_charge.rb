#encoding:utf-8
ActiveAdmin.register PersonalGetMobileCharge do
  menu parent: "市场报表", url: 'personal_get_mobile_charges'
  config.clear_action_items!


  controller do
    def index
      @rank={}
      @button = params[:button]
      @display_date = []
      @match_seq = []
      @d_matches = {}
      first_personal = UserMobileList.first
      unless first_personal.nil?
        user_id = params[:user_id].nil? ? first_personal.user_id : params[:user_id]
      else
        render :text => "无用户参加比赛", :layout => 'active_admin'
      end
      unless params[:user_id].nil?
        @user_id = params[:user_id]
      else
        @user_id = User.find(user_id).user_id
      end
      #@user_id = 42611
      @year = params[:helperYear].nil? ? Time.now.strftime("%Y") : params[:helperYear]
      @month = params[:helperMonth].nil? ? Time.now.strftime("%m") : params[:helperMonth]
      @day = params[:helperDay].nil? ? Time.now.strftime("%d") : params[:helperDay]
      @date = "#{@year}#{@month}#{@day}"
      @begin_seq = @date.to_i*1000
      next_day = 1.day.since("#{@year}-#{@month}-#{@day}".to_time).strftime("%Y%m%d")
      @end_seq = next_day.to_i*1000
      if @button == "buttondate"
        #@records = MatchMember.where("user_id"=>@user_id)
        @records = MatchMember.where("user_id" => @user_id).between(match_seq: @begin_seq..@end_seq).order_by("match_seq asc")
      else
        #@records = MatchMember.where("user_id"=>@user_id).between(match_seq:@begin_seq..@end_seq).order_by("match_seq asc")
        @records = MatchMember.where("user_id" => @user_id)

      end
      Rails.logger.debug("personal_get_mobile_charge.index.@records=>#{@records}")
      @records.each do |record|
        match_seq = record.match_seq
        match_date = match_seq.to_s[0, 8]
        p match_date
        @display_date.push(match_date) if !@display_date.include?(match_date)
        rank = {}
        rank["match_seq"] = match_seq
        rank["rank"] = record.rank
        @d_matches["#{match_date}"] = @d_matches["#{match_date}"] || []
        @d_matches["#{match_date}"].push(rank)
      end
      Rails.logger.debug("personal_get_mobile_charge.index.@rank=>#{@rank}")
      @begin = @display_date.first.to_i
      @end = @display_date.last.to_i
      #@date = ch_date.nil? ? Time.now.strftime("%Y-%m-%d"):ch_date
      #@records =
      render 'index', :layout => 'active_admin'
    end
  end

end