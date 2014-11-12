#encoding:utf-8
ActiveAdmin.register SpecialMatchArrangement do
  menu :priority => 1, :label => proc{"index"}
  menu parent: "比赛相关"
  #def match_arrage
  #
  #end

  collection_action :match_arrage, :method => :post do
    id = current_super_user.email
    unless params.nil?
      unless params["arrange_time"].nil?
        time = JSON.parse(params[:arrange_time])
        flag = true

        time.each do |t|
          if t["begin_time"].nil? or t["duration"].nil? or t["count"].nil?
            flag = false
          end
        end

        if flag && params[:id].blank?
          record = SpecialMatchArrangement.new
          record.room_type = params["room_type"]
          record.special_day = params["special_day"]
          record.entry_fee = params["match_fee"]
          record.match_ante = params["match_ante"]
          record.time_plan = time
          record.state = params["state"]
          record.created_by = id
          record.save
          redirect_to({:action => :index}, :notice => "提交成功")
        elsif params[:id].blank?
          redirect_to({:action => :index}, :notice => "添加失败")
        end

        unless params[:id].blank?
          record = SpecialMatchArrangement.find(params[:id])
          record.room_type = params["room_type"]
          record.special_day = params["special_day"]
          record.entry_fee = params["match_fee"]
          record.match_ante = params["match_ante"]
          record.time_plan = time
          record.state = params["state"]
          record.created_by = id
          record.save
          redirect_to({:action => :index}, :notice => "修改成功")
        end

      end
    end


  end

  controller do
    def new
      render 'new', :layout => 'active_admin'
    end

    def edit
      @id = params[:id]
      @record = SpecialMatchArrangement.find(@id)
      render 'new', :layout => 'active_admin'
    end

    #def match_arrage
    #
    #end

    #def index
    #  render 'new', :layout => 'active_admin'
    #
    #end

  end

end
