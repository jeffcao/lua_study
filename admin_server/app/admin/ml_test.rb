#encoding: utf-8

ActiveAdmin.register MlTest do
  menu :if => proc { can? :manage, MlTest }

  #action_item do
  #  link_to "新建推送",new_admin_ml_test_path
  #end
  #
  #collection_action :new, :method => :get do
  #
  #end

  def new
    render 'new', :layout => 'active_admin'
  end

  controller do
    def new_msg
      if params[:create].nil?
        render 'new', :layout => 'active_admin'
        return
      else
        content = params[:content]
        year = params[:helperYear]
        month = params[:helperMonth]
        day = params[:helperDay]
        hour = params[:helpHour]
        mintue = params[:helpMintue]
        p_time = "#{year}-#{month}-#{day} #{hour}:#{mintue}:00"


        level = params[:level]
        position = params[:position]
        editor = @@current_user.email
        edit_time = Time.now
        type = 0
        GamePushMessage.create("content"=>content,"p_time"=>p_time,"level"=>level,
                     "editor"=>editor,"edit_time"=>edit_time,"type"=>type,
                     "advice"=>"","position"=>position,"auditor"=>"","audit_time"=>""
                     )

        redirect_to({:action => :index}, :notice => "创建成功")
      end
    end


    def create
      page_size = 5

      @page=params[:page].nil? ? 1 : params[:page].to_i
      @total_page=1
      @zt =["审核中", "审核通过", "审核不通过", "等待推送", "推送已送达", "推送已取消"]

      unless params[:button1].nil?
        @button1 = params[:button1]
        type = @button1.to_i
        total = GamePushMessage.where("type" => type).count
        @total_page = total%page_size == 0 ? total/page_size : total/page_size + 1
        @records = GamePushMessage.where("type" => type).offset((@page-1)*page_size).limit(page_size).order_by("edit_time desc")

      else
        @records = GamePushMessage.all
      end
      render 'view', :layout => 'active_admin'


    end

    def index
      @publishing_count =GamePushMessage.where("type"=>0).count
      @published_count =GamePushMessage.where("type"=>1).count
      @not_publish_count =GamePushMessage.where("type"=>2).count
      @cancel_count =GamePushMessage.where("type"=>5).count
      @ready_push =GamePushMessage.where("type"=>3).count





      @msg = GamePushMessage.where("type"=>1).limit(5).order_by("audit_time desc")
      @page = 1
      total = GamePushMessage.count
      page_size = 5
      @total_page = total%page_size == 0 ? total/page_size : total/page_size + 1
      page = params[:page].to_i
      @@current_user = current_super_user
      @zt =["审核中", "审核通过", "审核不通过", "等待推送", "推送已送达", "推送已取消"]
      if params[:page].nil?

        @records = GamePushMessage.offset(0).limit(5).order_by("edit_time desc")
      else
        @page = params[:page].to_i
        unless params[:button1].nil?
          @button1 = params[:button1].to_i
          p "caca#{@button1}"
          @records = GamePushMessage.where("type"=>@button1).offset((page-1)*page_size).limit(page_size).order_by("edit_time desc")
        else
          p "caca1#{@button1}"

          @records = GamePushMessage.offset((page-1)*page_size).limit(page_size).order_by("edit_time desc")
        end
      end
      @size = @records.size - 1
      render 'view', :layout => 'active_admin'

    end

    def tuisong

      str = '<table class="index_table index" id="tuisong" >
                         <tr class="even" bgcolor="#d9e4ec">
                           <th class="sortable sorted-desc id">1</th>
                           <th class="sortable sorted-desc id">2</th>
                           <th class="sortable sorted-desc id">3</th>
                           <th class="sortable sorted-desc id">4</th>
                           <th class="sortable sorted-desc id">5</th>
                           <th class="sortable sorted-desc id">6</th>
                           <th class="sortable sorted-desc id">7</th>
                           <th class="sortable sorted-desc id">8</th>
                           <th class="sortable sorted-desc id">9</th>
                         </tr></table>'
      render :text => str


    end

    def action
      @msg = GamePushMessage.where("type"=>1).limit(5).order_by("audit_time desc")

      @current_user = @@current_user
      @zt =["审核中", "审核通过", "审核不通过", "等待推送", "推送已送达", "推送已取消"]
      unless params[:id].nil?
        @id = params[:id]
        @record = GamePushMessage.find(@id)
        if @record.type.to_i == 2
          @log_record = GamePushMessageLog.where("message"=>@id).offset(1).order_by("created_at desc")
        end
      end
      render 'action', :layout => 'active_admin'
    end

    def tt
      #@current_user = current_super_user.id
      id = params[:id]
      email = @@current_user.email
      content = params[:content]
      p_time = params[:p_time]
      advice = params[:advice]
      level = params[:level]
      position = params[:position]
      record = GamePushMessage.find(id)
      if record.nil?
        redirect_to({:action => :index}, :notice => "记录不存在，操作失败")
        return

      end


      unless params[:tongguo].nil?
        record.type = 1
        record.advice = advice
        record.auditor = email
        record.audit_time = Time.now
        record.save
        redirect_to({:action => :index}, :notice => "消息#{id}审核成功")
        return
      end
      unless params[:edit].nil?
        record.type = 0
        record.content = content
        record.p_time = p_time
        record.level = level
        record.position = position
        record.editor = email
        record.save

        redirect_to({:action => :index}, :notice => "消息#{id}修改成功")
        return
      end
      unless params[:cancel].nil?
        record.type = 5
        record.editor = email
        record.advice = advice
        record.save
        redirect_to({:action => :index}, :notice => "消息#{id}取消推送")
        return
      end

      unless params[:resume].nil?
        record.type = 3
        record.editor = email
        record.save
        redirect_to({:action => :index}, :notice => "消息#{id}恢复推送成功")
        return
      end

      unless params[:tuisong].nil?
        record.type = 3
        record.update_attributes("tuisong"=>email)
        record.save
        redirect_to({:action => :index}, :notice => "消息#{id}恢复等待推送")
        return
      end

      unless params[:butongguo].nil?
        record.type = 2
        record.auditor = email
        record.advice = advice
        record.audit_time = Time.now
        record.save
        GamePushMessageLog.create("message"=>record.id.to_s,"content"=>record.content,"auditor"=>record.auditor,"advice"=>record.advice,"audit_time"=>record.audit_time,"created_at"=>Time.now)
        redirect_to({:action => :index}, :notice => "消息#{id}不通过审核")
        return
      end
    end

    def txt
      render :text => 0, :content_type => 'application/text'
    end

    def gundong_msg
      records = GamePushMessage.where("type"=>1).limit(5).order_by("audit_time desc")
      i=0
      str = ""
      for i in 0..records.size-1 do
          str =str + "等待推送:" + "#{records[i].content}等待推送<br>"
      end
      str
    end
  end

end
