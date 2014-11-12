#encoding: utf-8
ActiveAdmin.register PayMobile do
  menu parent: "市场报表", url: '/admin/pay_mobiles'

  config.clear_action_items!


  #collection_action :batch_upload, :method => :post do
  #
  #
  #  redirect_to( {:action => :index}, :notice => "")
  #end

  controller do

    def index
      #render :text=>"123",:layout => 'active_admin'
      flag = false
      unless params[:file].nil?
        unless params[:file]['file'].nil?
          name = getFileName(params[:file]['file'].original_filename)
          flag = uploadFile(params[:file]['file'])
        end
      end
      unless params[:mobile].nil?

        record = KefuPayMobile.new
        record.mobile = params[:mobile]
        record.pay_type = params[:fangshi]
        record.status = params[:status]
        record.cause = params[:reason]
        #{request.protocol}#{request.host_with_port}
        record.picture_path = "/upload/#{name}" unless params[:file].nil?
        record.save
      end
      if flag
        redirect_to({:action => :index}, :notice => "提交成功")
      else
        render 'index', :layout => 'active_admin'
      end

    end

    def create
      index
    end

    def save
      render :text => "success"
    end


    def uploadFile(file)
      if !file.original_filename.empty?
        @filename=getFileName(file.original_filename)
        path = SystemSetting.find_by_setting_name("upload_path").setting_value
        File.open("#{path}/#{@filename}", "wb") do |f|
          f.write(file.read)
        end
        true
      end
    end

    def getFileName(filename)
      if !filename.nil?
        Time.now.strftime("%Y%m%d%H%M%S") + '_' + filename
      end
    end

  end
end