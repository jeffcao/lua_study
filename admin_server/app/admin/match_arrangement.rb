#encoding:utf-8

ActiveAdmin.register MatchArrangement do

  menu :priority => 1, :label => proc{"index"}
  menu parent: "比赛相关"

  collection_action :match_arrage, :method => :post do
    id = current_super_user.email
    unless params.nil?
      flag = true

      unless params["room_type"].nil?
        flag = true
        ["monday","tuesday","wednesday","thursday","friday","saturday","sunday"].each do |week|
          p week
          p params["#{week}"]
          time = JSON.parse(params["#{week}"])
          if time.size > 0
            #time.each do |t|
              t = time["time_plan"].first
              if t["begin_time"].nil? or t["duration"].nil? or t["count"].nil?
                flag = false
              end
            #end
          end
        end
        if flag && params[:id].blank?
          record = MatchArrangement.new
          record.room_type = params["room_type"]
          record.monday = JSON.parse(params["monday"])
          record.tuesday = JSON.parse(params["tuesday"])
          record.wednesday = JSON.parse(params["wednesday"])
          record.thursday = JSON.parse(params["thursday"])
          record.friday = JSON.parse(params["friday"])
          record.saturday = JSON.parse(params["saturday"])
          record.sunday = JSON.parse(params["sunday"])
          record.where("room_type"=>params["room_type"]).update("state"=>1) unless record.where("room_type"=>params["room_type"]).nil?
          record.update_attributes("state" => 0)
          record.created_by = id
          record.save
          redirect_to({:action => :index}, :notice => "提交成功")
        elsif params[:id].blank?
          redirect_to({:action => :index}, :notice => "添加失败")
        end

        unless params[:id].blank?
          record = MatchArrangement.find(params[:id])
          record.room_type = params["room_type"]
          record.monday = JSON.parse(params["monday"])
          record.tuesday = JSON.parse(params["tuesday"])
          record.wednesday = JSON.parse(params["wednesday"])
          record.thursday = JSON.parse(params["thursday"])
          record.friday = JSON.parse(params["friday"])
          record.saturday = JSON.parse(params["saturday"])
          record.sunday = JSON.parse(params["sunday"])
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
      @record = MatchArrangement.find(@id)
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
