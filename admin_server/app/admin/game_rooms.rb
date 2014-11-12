#encoding: utf-8

ActiveAdmin.register GameRoom do
  menu :if => proc{can? :manage,GameRoom}
  menu parent: "游戏相关配置"

  #controller.authorize_resource
  #action_item do
  #  link_to "测试", batch_ids_admin_game_rooms_path
  #end

  collection_action :batch_ids, :method => :get do
    @user_count =User.where("robot!=1").count()
    @online_count = 4
    @room_count = GameRoom.count()
    @online_room = GameRoom.where("status=0").count
    @table_count = 0
    rooms = GameRoom.where("status=0")
    rooms.each do |room|
      room_msg = GameRoomUtility.get_room(room.id)
      @table_count = room_msg.tables.length + @table_count
    end
  end

  collection_action :online_players, :method => :get do
    @a=[1,3,4,5,6]
    #rooms = GameRoom.where("status=0")
    #@users =[]
    #rooms.each do |room|
    #  room_msg = GameRoomUtility.get_room(room.id)
    #  room_msg.tables.each do |table|
    #    table_msg = GameTable.get_game_table(table)
    #    game_users = table_msg.table_info.users
    #    if game_users.length >0
    #      game_users.each do |user_id|
    #        tmp_user = []
    #        user_info = Player.get_player(user_id) if user_id.to_i > 50000
    #        tmp_user=nil
    #
    #      end
    #    end
    #
    #  end
    #end
  end

  #collection_action :batch_upload, :method => :post do
  #  value = params[:game_rooms][:user_id]
  #  value1 = params[:game_rooms][:id]
  #  redirect_to({:action => :batch_ids}, :notice => "#{value}")
  #end
  #index do
  #
  #  column :name
  #  column :port do |room|
  #    room.game_room_url[0].port
  #  end
  #  default_actions
  #end


end
