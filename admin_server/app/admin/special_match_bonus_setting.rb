#encoding:utf-8
ActiveAdmin.register SpecialMatchBonusSetting do
  menu :priority => 1, :label => proc{"index"}
  menu parent: "比赛相关"
  index do
    column :id
    column :room_type
    column :match_name
    column :special_day
    column :first
    column :second
    column :third
    column :fourth
    column :fifth
    column :sixth
    column :seventh
    column :eighth
    column :ninth
    column :tenth
    column :created_by
    default_actions
  end

  collection_action :bonus_arrange, :method => :post do
    id = current_super_user.email
    if params[:id].blank?
      record = SpecialMatchBonusSetting.new
    elsif !params[:id].blank?
      record = SpecialMatchBonusSetting.find(params[:id])
    end
    record.room_type = params[:room_type]
    record.first = params[:first]
    record.second = params[:second]
    record.third = params[:third]
    record.fourth = params[:fourth]
    record.fifth = params[:fifth]
    record.special_day = params[:special_day]
    record.update_attributes("sixth" => params[:sixth])
    record.update_attributes("seventh" => params[:seventh])
    record.update_attributes("eighth" => params[:eighth])
    record.update_attributes("ninth" => params[:ninth])
    record.update_attributes("tenth" => params[:tenth])
    record.update_attributes("match_name" => params[:match_name])
    record.update_attributes("created_by" => id)
    redirect_to({:action => :index}, :notice => "提交成功")
  end

  controller do
    def new
      render 'new', :layout => 'active_admin'
    end

    def edit
      @id = params[:id]
      @record = SpecialMatchBonusSetting.find(@id)
      render 'new', :layout => 'active_admin'

    end


  end

end
