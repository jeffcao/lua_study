#encoding:utf-8

ActiveAdmin.register EveryHourOnlineUser do
  menu parent: "市场报表", url: '/admin/every_hour_online_users?order=date_desc'
  config.clear_action_items!
  index do
    column "日期",:date
    column "00:00点",:zero
    column "01:00点",:one
    column "02:00点",:two
    column "03:00点",:three
    column "04:00点",:fourth
    column "05:00点",:fifth
    column "06:00点",:sixth
    column "07:00点",:seventh
    column "08:00点",:eighth
    column "09:00点",:ninth
    column "10:00点",:tenth
    column "11:00点",:eleventh
    column "12:00点",:twelfth
    column "13:00点",:thirteenth
    column "14:00点",:fourteenth
    column "15:00点",:fifteenth
    column "16:00点",:sixteenth
    column "17:00点",:seventeenth
    column "18:00点",:eighteenth
    column "19:00点",:nineteenth
    column "20:00点",:twentieth
    column "21:00点",:twenty_first
    column "22:00点",:twenty_second
    column "23:00点",:twenty_third
    #column :two
    #column :three
    #column :fourth
    #column :fifth
    #column :sixth
    #column :seventh
    #column :eighth
    #column :ninth
    #column :tenth
    #column :eleventh
    #column :twelfth
    #column :thirteenth
    #column :fourteenth
    #column :fifteenth
    #column :sixteenth
    #column :seventeenth
    #column :eighteenth
    #column :nineteenth
    #column :twentieth
    #column :twenty_first
    #column :twenty_second


  end


end