#encoding:utf-8
ActiveAdmin.register DistributeMobileCharge do
  menu :priority => 1, :label => proc{"index"}
  menu parent: "市场报表", url: '/admin/distribute_mobile_charges'
  config.clear_action_items!


  controller do
    def index
      @match_seq = []
      @value = {}
      @year = params["helperYear"].nil? ? Time.now.strftime("%Y").to_s : params["helperYear"]
      @month = params["helperMonth"].nil? ? Time.now.strftime("%m").to_s : params["helperMonth"]
      @day = params["helperDay"].nil? ? Time.now.strftime("%d").to_s : params["helperDay"]
      @date="#{@year}#{@month}#{@day}"
      @begin_seq = @date.to_i*1000
      next_day = 1.day.since("#{@year}-#{@month}-#{@day}".to_time).strftime("%Y%m%d")
      @end_seq = next_day.to_i*1000
      @records = MatchMember.where("room_type"=>3).between(match_seq:@begin_seq..@end_seq).order_by("match_seq asc")
      @records.each do |record|
        @match_seq.push(record.match_seq) if !@match_seq.include?(record.match_seq)
        key = "#{record.match_seq}_#{record.rank}"
        @value["#{key}"] = record.user_id
      end
      render 'index',:layout=>'active_admin'
    end
  end
end