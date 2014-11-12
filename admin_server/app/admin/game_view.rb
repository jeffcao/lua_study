#encoding: utf-8
ActiveAdmin.register GameView do
  #config.comments = false
  #before_filter do
  #  @skip_sidebar = true
  #end
  ## menu false
  config.clear_action_items! # this will prevent the 'new button' showing up
  controller do

    def index
      # some hopefully useful code
      @user_count =user_count
      @room_count = room_count
      @online_room = online_room_count
      @online_count, @table_count = online_user_count
      @instances = get_game_server_instances
      @login_con_count = Redis.current.get(ResultCode::LOGIN_SERVER_CONNECTIONS_COUNT_KEY)
      @hall_con_count = Redis.current.get(ResultCode::HALL_SERVER_CONNECTIONS_COUNT_KEY)
      @game_con_count = Redis.current.get(ResultCode::GAME_SERVER_CONNECTIONS_COUNT_KEY)
      render 'view', :layout => 'active_admin'
    end

    def view

      respond_to do |format|
        @user_count =user_count
        online_count, table_count = online_user_count
        @room_count = room_count
        online_room = online_room_count
        instances = get_game_server_instances

        Rails.logger.debug("view")
        Rails.logger.debug("view, instances=>#{instances.to_json}")

        #format.json { render :json => {user_count: "#{@user_count}",
        #                               online_count: "#{online_count}",
        #                               room_count: "1",
        #                               online_room: "1",
        #                               table_count: "3",
        #                               instances: "3",
        #                               login_con_count: "4",
        #                               hall_con_count: "1",
        #                               game_con_count: "1"
        #} } # and this


        format.json { render :json => {user_count: "#{@user_count}",
                                       online_count: "#{online_count}",
                                       room_count: "#{@room_count}",
                                       online_room: "#{online_room}",
                                       table_count: "#{table_count}",
                                       instances: "#{instances.to_json}",
                                       login_con_count: "#{@login_con_count}",
                                       hall_con_count: "#{@hall_con_count}",
                                       game_con_count: "#{@game_con_count}"
        } } # and this
      end
    end

    def product_item
      msg = []
      product_id = params[:product_id]
      if product_id.to_i ==0
        render 'test', :layout => 'active_admin'
        return
      end
      product = GameProduct.find(product_id)
      maps = product.product_product_item
      maps.each do |map|
        value = map.game_product_item_id
        value = "#{value}" + "#" + "#{map.count}"
        #msg.push("#{map.game_product_item_id}#")
        msg.push("#{value}")
      end
      render :text => msg.join(",")

    end

    def login_log

    end

    def online_players
      @o_players = []
      if params[:user_id].nil?
        rooms = GameRoom.where("status=0")
        tables = tables_msg(rooms)
        tables.each do |table|
          users = table[:user_id]
          next if users.size < 1
          users.each do |user_id|
            user = Player.get_player(user_id)
           # next if GameRoom.find(user.player_info.room_id).nil?
            @o_players.push({user_id: user_id,
                             nick_name: user.player_info.nick_name,
                             gender: user.player_info.gender,
                             table_id: user.player_info.table_id,
                             room_name: user.player_info.room_id,
            #                 room_name: GameRoom.find(user.player_info.room_id).name  ,
                             score: User.find_by_user_id(user_id).game_score_info.score,
                             state: user.player_info.state,
                             robot: (user.player_info.is_robot.to_i > 0 ? "yes" : "no")
                            })
          end
        end
      else
        @user_id = params[:user_id]
        user = Player.get_player(@user_id)
        @o_players.push({user_id: @user_id,
                         nick_name: user.player_info.nick_name,
                         gender: user.player_info.gender,
                         table_id: user.player_info.table_id,
                         room_name: GameRoom.find(user.player_info.room_id).name,
                         score: User.find_by_user_id(@user_id).game_score_info.score,
                         state: user.player_info.state,
                         robot: (user.player_info.is_robot.to_i > 0 ? "yes" : "no")
                        })

      end
      render 'online_players', :layout => 'active_admin'
    end

    def product_map
      @product = GameProduct.all
      @product_item = GameProductItem.all
      if params[:test]
        product_id = params[:test]
        items_is = params[:item]
        ProductProductItem.where(["game_product_id=?", product_id]).delete_all()
        unless items_is.blank?
          items_is.each do |item|
            new_map = ProductProductItem.new
            new_map.game_product_id = product_id
            new_map.game_product_item_id = item
            game_product_item = GameProductItem.find(item)
            if game_product_item.beans < 1
              name = "ka_#{item}"
              new_map.count = params[:"#{name}"]
            end
            new_map.save
          end
        end
      end
      render 'test', :layout => 'active_admin'
    end

    def game_tables
      @tables = []
      rooms = GameRoom.where("status=0")
      if params[:table_id]
        tables_state = ["准备就绪", "已经就绪", "叫地主", "出牌", "牌局结束"]
        @table_id = params[:table_id]
        msg = GameTable.get_game_table(@table_id)
        room_id = msg.table_info.room_id
        @tables.push({table_id: "#{@table_id}",
                      room_name: "#{GameRoom.find(room_id).name}",
                      user_id: "#{msg.users}",
                      state: "#{tables_state[msg.table_info.state.to_i]}"})
      else
        @tables = tables_msg(rooms)
      end
      render 'game_tables', :layout => 'active_admin'
    end

    def charge_user
      count = PurchaseRequestRecord.count()
      limit_size = 30
      unless params[:user_id].nil?
        records = PurchaseRequestRecord.where("user_id=#{params[:user_id]}")
      end
      unless params[:zt].nil?
        records = records.select{|r|r.state == params[:zt].to_i} if params[:zt].to_i!=3
      end
      count = records.count unless records.nil?

      @page_count = count/limit_size
      if params[:page].nil?
        @page = 0
      else
        @page = params[:page].to_i
      end
      @records = []
      @user_id = nil
      @user_id = params[:user_id] unless params[:user_id].nil?
      @zt = nil
      @zt = params[:zt] unless params[:zt].nil?
      charge_user_id = @user_id
      action = ["处理中", "付费成功", "付费失败"]
      trades = PurchaseRequestRecord.where(["id>?", 0]).order("id desc").offset(limit_size*@page).limit(limit_size)
      if charge_user_id && charge_user_id.to_i >0
        trades = trades.where(["user_id=?", charge_user_id])
      end
      if @zt && @zt.to_i < 3
        trades = trades.where(["state=?", @zt])
      end

      trades.each do |trade|
        prop = GameProduct.where({:id=>trade.game_product_id}).first
        user_id = trade.user_id
        user = User.find_by_user_id(user_id)
        u_name = trade.request_seq[0,3]
        u_name =  user.user_profile.nick_name unless user.nil?
        unless prop.nil?
          prop_id =  prop.id
          prop_name = prop.product_name
          prop_price = prop.price.to_f/100
        end

        @records.push({id: trade.id,
                       user_id: user_id,
                       nick_name: u_name,
                       product_id: prop_id,
                       product_name: prop_name,
                       price: prop_price,
                       sms: trade.request_command,
                       action: action[trade.state],
                       date:trade.created_at

                      })


      end

      render 'charge_user', :layout => 'active_admin'
    end

    def room_msg
      @rooms = []
      rooms = GameRoom.where("status=0")
      if params[:room_id]
        @room_id = params[:room_id]
        rooms = GameRoom.where(["status=? and id=?", 0, @room_id])
      end
      rooms.each do |room|
        room_id = room.id
        room = GameRoomUtility.get_room(room.id)
        @rooms.push({room_name: "#{room.name}",
                     table_id: "#{room.tables}",
                     waiting_tables: "#{room.waiting_tables}",
                     busy_tables: "#{room.tables-room.waiting_tables}",
                     online_user_count: GameRoomUtility.get_room_online_count(room_id),
                     limit_online_count: "#{room.limit_online_count}",
                     max_qualification: "#{room.max_qualification}",
                     min_qualification: "#{room.min_qualification}"
                    })
      end
      render 'game_rooms', :layout => 'active_admin'

    end

    def table_user
      @id = params[:id] if params[:id] #待释放的用户ID
      @table_id = params[:table_id].nil? ? nil : params[:table_id]
      @room_id =  params[:room_id].nil? ? nil : params[:room_id]
      @table_users = []
      @user_msg = []
      if @id
        instances = get_game_server_instances
        instance_id = instances[rand(0..instances.length-1)]
        player = Player.get_player(@id)
        instance_id = "" if player.in_game?
        DdzAdminServer::Synchronization.publish({:user_id => @id,
                                                 :notify_type => GameTimingNotifyType::KICK_USER,
                                                 :server_id => instance_id
                                                })
      end
      if @table_id.nil?
        rooms = GameRoom.where("status=0")
        tables = tables_msg(rooms)
        tables.each do |table|
          users = table[:user_id]
          table_id = table[:table_id]
          @user_msg, room_name = get_user_msg(users)
          @table_users.push({table_id: "#{table_id}",
                             room_name: "#{room_name}",
                             users: @user_msg
                            })
        end
      else
        table = GameTable.get_game_table(@table_id, @room_id)
        users = table.users
        @user_msg, room_name = get_user_msg(users)
        @table_users.push({table_id: @table_id,
                           room_name: "#{room_name}",
                           users: @user_msg
                          })
      end


    end


    def user_count
      User.where("robot!=1").count()
    end

    def room_count
      GameRoom.count()
    end

    def online_room_count
      GameRoom.where("status=0").count
    end

    def online_user_count
      online_count = 0
      table_count = 0
      rooms = GameRoom.where("status=0")
      rooms.each do |room|
        room_msg = GameRoomUtility.get_room(room.id)
        table_count = room_msg.tables.length + table_count
        Rails.logger.debug("online_user_count, room.tables=>#{room_msg.tables.to_json}")
        if room_msg.tables.length >0
          room_msg.tables.each do |table_id|
            table_msg = GameTable.get_game_table(table_id, room_msg.room_id)
            Rails.logger.debug("online_user_count, table_msg.users=>#{table_msg.users.to_json}")
            if table_msg.users_count >0
              table_msg.users.each do |user_id|
                online_count = online_count + 1 if user_id.to_i>49999
              end
            end
          end
        end
      end
      [online_count, table_count]
    end

    def tables_msg(rooms)
      tables_state = ["准备就绪", "已经就绪", "叫地主", "出牌", "牌局结束"]
      tables_msg=[]
      rooms.each do |room|
        room_msg = GameRoomUtility.get_room(room.id)
        unless room_msg.nil?
          room_msg.tables.each do |table_id|
            message = GameTable.get_game_table(table_id, room_msg.room_id)
            state = tables_state[message.table_info.state.to_i]
            tables_msg.push({table_id: "#{table_id}", room_name: "#{room_msg.name}", user_id: message.users, state: "#{state}"})
          end
        end
      end
      tables_msg
    end

    def get_user_msg(users)
      user_msg = []
      room_name = nil
      users.each do |user_id|
        user = Player.get_player(user_id)
        user_connection_info = PlayerConnectionInfo.from_redis(user_id)
        room = GameRoomUtility.get_room(user.player_info.room_id)
        break if room.nil?
        room_name = room.name
        user_msg.push({user_id: user_id,
                       nick_name: user.player_info.nick_name,
                       gender: user.player_info.gender,
                       score: User.find_by_user_id(user_id).game_score_info.score,
                       socket: user_connection_info.nil? ? "" : user_connection_info.game_server_id,
                       state: user.player_info.state,
                       robot: (user.player_info.is_robot.to_i>0 ? "yes" : "no"),
                       dead?: (user.in_game? ? "no" : "yes"),
                       last_action_time: Time.at(user.player_info.current_action_seq.split("_")[2].to_i).to_s
                      })
      end
      [user_msg, room_name]
    end

    def get_game_server_instances
      tmp_instances = `ps aux |grep thin |grep ddz_game_server | awk '{print $2}'`
      tmp_instances = tmp_instances.split("\n")
      tmp_instances = tmp_instances - [tmp_instances.last]
    end

    def bean_distribution
      vip_level = ["普通用户","初级vip","中级vip","高级vip","特级vip"]
      @month = params[:month]
      if @month.nil?
        month = Time.now.strftime("%Y-%m")
      else
        month = @month
      end
      tmp_month = month.dup
      tmp_month.gsub!("-","")
      table_name = "dialogue_count_" + "#{tmp_month}"
      vip_table_name = "vip_count_" + "#{tmp_month}"
      VipCount.check_table_name(vip_table_name)
      DialogueCount.check_table_name(table_name)
      @vip = {}
      vip_data = VipCount.connection.execute("select vip_level,count(*) from users where updated_at like '%#{month}%' group by vip_level ")
      vip_data.each do |vip_tmp_data|
        key = vip_tmp_data[0].to_i
        @vip.merge!("#{vip_level[key]}" => vip_tmp_data[1])
      end
      @dialogue = {}
      dialogue_data = DialogueCount.connection.execute("select dialogue_id,count from #{table_name}")
      dialogue_data.each do |tmp_data|
        @dialogue.merge!("#{tmp_data[0]}"=>tmp_data[1])
      end

      @date = []
      date = Date.new(2013,7)
      @date.push(date.to_s[0,7])
      while date.strftime("%Y%m") < Time.now.strftime("%Y%m")
         date = date>>1
         @date.push(date.to_s[0,7])
      end
      @date.reverse!
      @beans = ["0-999","1000-9999","10000-49999","50000-99999","100000-199999","200000-399999","400000-999999","1000000"]
      @bean_data = {}
      @beans.each do |bean|
        min = bean.split("-")[0].to_i
        max = bean.split("-")[1].to_i
        count = GameScoreInfo.where(["score>=? and score<=? and updated_at like ?",min,max,"%#{month}%"]).count
        @bean_data.merge!("#{bean}"=>count)
      end
      @bean_data
    end

    def visit_count
      @login_count = login_count_by_day

      @rooms = GameRoom.all
      @data = VisitRoomCount.group("game_room_id").count
      #@data = {1=>10,2=>30,3=>43,4=>45,5=>65}
      @ui_count = VisitUiCount.all
      @visit_data = {}
      @time_data = {}
      @ui_count.each do |ui|
        @visit_data.merge!("#{ui.ui_id}"=>ui.click_count)
        @time_data.merge!("#{ui.ui_id}"=>ui.time_count)
      end
    end

    def login_count_by_day
      date = Time.now.strftime("%Y-%m-%d")
      login_count = {}
      flag = {}
      table = "login_logs_#{date.gsub("-","").to_s[0,6]}"
      LoginLog.check_table_name
      all_user = LoginLog.connection.execute("select user_id,created_at from #{table} where created_at like '#{date}%'")
      all_user.each do |user|
        user_id = user[0]
        time = user[1].to_s[11,2].to_i + 8
        login_count[time] = login_count[time].to_i + 1 if flag[user_id].nil?
        flag[user_id] = 1
      end
      login_count
    end



  end
end