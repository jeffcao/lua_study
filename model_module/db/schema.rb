# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140904082655) do

  create_table "accept_message_users", :force => true do |t|
    t.string   "name"
    t.string   "mobile"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "week_date"
    t.string   "activity_name"
    t.string   "activity_content"
    t.string   "activity_object"
    t.string   "activity_memo"
    t.string   "activity_model"
    t.string   "activity_parm"
    t.string   "activity_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "apk_signature_public_keys", :force => true do |t|
    t.integer  "code"
    t.string   "name"
    t.text     "public_key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "app_error_acceptors", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "app_errors", :force => true do |t|
    t.datetime "raise_time"
    t.integer  "appid"
    t.string   "appname"
    t.string   "version"
    t.string   "imei"
    t.string   "mac"
    t.string   "net_type"
    t.string   "model"
    t.string   "manufactory"
    t.string   "brand"
    t.string   "os_release"
    t.string   "fingerprint"
    t.string   "exception_info"
    t.string   "app_bulid"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ban_words", :force => true do |t|
    t.string   "word"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "zz_word"
  end

  create_table "bankrupts", :force => true do |t|
    t.integer  "user_id"
    t.string   "date"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "blacklists", :force => true do |t|
    t.integer  "black_user"
    t.string   "imsi"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ddz_partners", :force => true do |t|
    t.string   "appid"
    t.string   "product_id"
    t.string   "enable"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "sms_content"
  end

  create_table "ddz_sheets", :force => true do |t|
    t.string   "date"
    t.string   "game_id"
    t.integer  "day_max_online",    :default => 0
    t.integer  "avg_hour_online"
    t.integer  "day_login_user"
    t.integer  "total_online_time"
    t.integer  "total_user"
    t.integer  "add_day_user"
    t.integer  "total_exp_user"
    t.integer  "day_exp_user"
    t.integer  "add_exp_user"
    t.float    "total_day_money"
    t.float    "arpu"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "platform"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dialogue_counts", :force => true do |t|
    t.integer  "dialogue_id"
    t.integer  "count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "dialogues", :force => true do |t|
    t.string   "content"
    t.integer  "vip_flag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "every_hour_online_users", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.string   "brand"
    t.string   "model"
    t.string   "display"
    t.string   "os_release"
    t.text     "content"
    t.string   "manufactory"
    t.string   "string"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "game_match_logs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_product_items", :force => true do |t|
    t.integer  "game_id"
    t.string   "item_name"
    t.string   "item_note"
    t.string   "cate_module"
    t.string   "using_point"
    t.integer  "beans"
    t.string   "item_feature"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "icon",         :default => "0"
    t.integer  "item_sort",    :default => 0
    t.integer  "item_type",    :default => 0
  end

  create_table "game_product_sell_counts", :force => true do |t|
    t.integer  "game_product_id"
    t.integer  "sell_count"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "cp_sell_count",   :default => 0
  end

  create_table "game_products", :force => true do |t|
    t.integer  "game_id"
    t.string   "product_name"
    t.integer  "product_type"
    t.string   "price"
    t.integer  "sale_limit"
    t.string   "note"
    t.integer  "state",        :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "icon",         :default => "0"
    t.integer  "product_sort", :default => 0
  end

  create_table "game_room_urls", :force => true do |t|
    t.string   "domain_name"
    t.string   "port"
    t.integer  "status"
    t.integer  "game_room_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "game_rooms", :force => true do |t|
    t.string   "name"
    t.integer  "ante"
    t.integer  "min_qualification"
    t.integer  "max_qualification"
    t.integer  "status"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "fake_online_count",  :default => 0
    t.integer  "limit_online_count", :default => 0
    t.integer  "room_type",          :default => 1
  end

  create_table "game_score_infos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "score",      :default => 0
    t.integer  "win_count",  :default => 0
    t.integer  "lost_count", :default => 0
    t.integer  "flee_count", :default => 0
    t.integer  "all_count",  :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "game_shop_cates", :force => true do |t|
    t.integer  "cate_id"
    t.string   "cate_name"
    t.integer  "game_id"
    t.string   "price"
    t.string   "sale_count"
    t.string   "cate_note"
    t.string   "cate_valid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "used_limit"
  end

  create_table "game_teaches", :force => true do |t|
    t.string   "content"
    t.string   "moment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_user_cates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cate_id"
    t.integer  "game_id"
    t.integer  "cate_count",      :default => 0
    t.integer  "used_flag"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "gift_bag_id"
    t.integer  "treasure_box_id"
  end

  create_table "get_mobile_charge_logs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "get_salaries", :force => true do |t|
    t.integer  "user_id"
    t.string   "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gift_bags", :force => true do |t|
    t.string   "name"
    t.string   "price"
    t.integer  "beans"
    t.integer  "sale_limit"
    t.integer  "sale_count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "note"
  end

  create_table "gift_maps", :force => true do |t|
    t.integer  "gift_bag_id"
    t.integer  "game_shop_cate_id"
    t.integer  "count"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "huo_yue_users", :force => true do |t|
    t.string   "date"
    t.integer  "hour"
    t.integer  "count_1"
    t.integer  "count_2"
    t.integer  "count_3"
    t.integer  "count_4"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "hour_total"
  end

  create_table "kefu_pay_mobiles", :force => true do |t|
    t.string   "mobile"
    t.string   "pay_type"
    t.integer  "status"
    t.text     "cause"
    t.string   "picture_path"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "levels", :force => true do |t|
    t.string   "name"
    t.integer  "min_score"
    t.integer  "max_score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "login_logs", :force => true do |t|
    t.string   "appid"
    t.string   "string"
    t.string   "imsi"
    t.string   "mac"
    t.string   "nick_name"
    t.string   "brand"
    t.string   "display"
    t.string   "fingerprint"
    t.string   "imei"
    t.string   "os_release"
    t.string   "version"
    t.string   "city_id"
    t.string   "integer"
    t.string   "province_id"
    t.string   "user_id"
    t.string   "login_ip"
    t.string   "login_time"
    t.string   "datetime"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "match_descs", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "match_system_settings", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "msisdn_regions", :force => true do |t|
    t.integer  "province_id"
    t.integer  "city_id"
    t.string   "operator"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "msisdn_regions", ["city_id"], :name => "index_msisdn_regions_on_city_id"
  add_index "msisdn_regions", ["province_id"], :name => "index_msisdn_regions_on_province_id"

  create_table "partmers", :force => true do |t|
    t.integer  "partner_appid"
    t.string   "partner_name"
    t.string   "link_man"
    t.string   "telephone"
    t.string   "address"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "email"
  end

  create_table "partner_month_accounts", :force => true do |t|
    t.integer  "appid"
    t.string   "name"
    t.string   "date"
    t.float    "account"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "partner_sheets", :force => true do |t|
    t.string   "date"
    t.integer  "appid"
    t.integer  "add_count",                :default => 0
    t.integer  "login_count",              :default => 0
    t.float    "consume_count",            :default => 0.0
    t.float    "month",                    :default => 0.0
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "total_users_count",        :default => 0
    t.integer  "one_day_left_user",        :default => 0
    t.integer  "three_day_left_user",      :default => 0
    t.integer  "seven_day_left_user",      :default => 0
    t.string   "email"
    t.integer  "one_day_left_user_rate",   :default => 0
    t.integer  "three_day_left_user_rate", :default => 0
    t.integer  "seven_day_left_user_rate", :default => 0
  end

  create_table "product_product_items", :force => true do |t|
    t.integer  "game_product_id"
    t.integer  "game_product_item_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "count",                :default => 0
  end

  create_table "prop_consume_codes", :force => true do |t|
    t.integer  "game_product_id"
    t.string   "consume_code"
    t.string   "operator_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "purchase_request_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "user_product_id"
    t.integer  "game_product_id"
    t.integer  "product_count"
    t.string   "request_seq"
    t.string   "request_type"
    t.text     "request_command"
    t.datetime "request_time"
    t.string   "operator_type"
    t.integer  "state"
    t.string   "reason"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "retry_times",     :default => 0
    t.integer  "appid",           :default => 0
    t.float    "price",           :default => 0.0
    t.float    "real_amount",     :default => 0.0
    t.integer  "server_flag"
  end

  create_table "purchase_transaction_records", :force => true do |t|
    t.string   "request_id"
    t.integer  "operator_user_id"
    t.string   "request_url"
    t.text     "request_message"
    t.string   "response_message"
    t.string   "request_ip"
    t.datetime "request_time"
    t.datetime "response_time"
    t.float    "elapsed_time"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "send_tiger_messages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "share_weibos", :force => true do |t|
    t.string   "url"
    t.string   "appkey"
    t.string   "title"
    t.string   "ralate_uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "weibo_type"
  end

  create_table "slot_machine_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spend_cate_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cate_id"
    t.integer  "cate_count"
    t.string   "spend_count"
    t.datetime "add_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "gift_bag_id"
    t.integer  "treasure_box_id"
  end

  create_table "super_users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "superadmin",             :default => false, :null => false
    t.string   "role"
  end

  add_index "super_users", ["email"], :name => "index_super_users_on_email", :unique => true
  add_index "super_users", ["reset_password_token"], :name => "index_super_users_on_reset_password_token", :unique => true

  create_table "system_messages", :force => true do |t|
    t.string   "content"
    t.integer  "message_type"
    t.integer  "failure_time"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "system_settings", :force => true do |t|
    t.string   "setting_name"
    t.string   "setting_value"
    t.string   "description"
    t.string   "enabled"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "flag",          :default => 0
    t.string   "payment"
  end

  create_table "tongji_ais", :force => true do |t|
    t.string   "match_seq"
    t.string   "role"
    t.string   "flag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "treasure_boxes", :force => true do |t|
    t.string   "name"
    t.integer  "beans"
    t.integer  "price"
    t.string   "note"
    t.integer  "give_beans"
    t.integer  "sale_limit"
    t.integer  "sale_count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ui_manages", :force => true do |t|
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "use_cate_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cate_id"
    t.string   "used_date"
    t.string   "datetime"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "used_cates", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cate_id"
    t.integer  "cate_valid"
    t.datetime "cate_begin"
    t.datetime "cate_last"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_game_teaches", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_teach_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_ids", :force => true do |t|
    t.integer  "next_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_mobile_lists", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_mobile_sources", :force => true do |t|
    t.integer  "user_id"
    t.float    "num"
    t.text     "source"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "mobile_type", :default => 0
  end

  create_table "user_product_item_counts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_product_item_id"
    t.integer  "item_count",           :default => 0
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "user_product_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "item_name"
    t.string   "item_note"
    t.string   "cate_module"
    t.string   "using_point"
    t.integer  "beans"
    t.string   "item_feature"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "game_item_id"
    t.string   "request_seq"
    t.integer  "state",        :default => 0
  end

  create_table "user_products", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.string   "product_name"
    t.integer  "product_type"
    t.string   "note"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "price"
    t.integer  "sale_limit"
    t.integer  "state"
    t.integer  "icon",         :default => 0
    t.integer  "product_sort", :default => 0
    t.integer  "request_seq",  :default => 0
  end

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "nick_name"
    t.integer  "gender",             :default => 2
    t.string   "email"
    t.string   "appid"
    t.string   "msisdn"
    t.string   "memo"
    t.datetime "last_login_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.datetime "birthday"
    t.string   "version"
    t.integer  "avatar",             :default => 0
    t.datetime "last_active_at"
    t.integer  "online_time"
    t.integer  "consecutive",        :default => 1
    t.integer  "day_total_game",     :default => 0
    t.integer  "day_continue_win",   :default => 0
    t.integer  "balance",            :default => 0
    t.integer  "total_balance"
    t.integer  "first_buy",          :default => 0
    t.integer  "used_credit",        :default => 0
    t.string   "payment"
    t.integer  "sign_up_get_charge", :default => 0
  end

  create_table "user_score_lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "nick_name"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_sheets", :force => true do |t|
    t.string   "date"
    t.integer  "online_time_count", :default => 0
    t.integer  "login_count",       :default => 0
    t.integer  "paiju_time_count",  :default => 0
    t.integer  "paiju_count",       :default => 0
    t.integer  "paiju_break_count", :default => 0
    t.integer  "bank_broken_count", :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "user_total_consume_lists", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_used_props", :force => true do |t|
    t.integer  "user_id"
    t.integer  "game_product_item_id"
    t.datetime "use_time"
    t.integer  "state"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "game_id",              :default => 0
  end

  create_table "users", :force => true do |t|
    t.integer  "user_id"
    t.string   "nick_name"
    t.integer  "game_id"
    t.string   "password_digest"
    t.string   "password_salt"
    t.string   "msisdn"
    t.string   "imsi"
    t.string   "mac"
    t.string   "os_release"
    t.string   "manufactory"
    t.string   "brand"
    t.string   "model"
    t.string   "display"
    t.string   "fingerprint"
    t.integer  "appid"
    t.string   "version"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "login_token"
    t.string   "imei"
    t.integer  "robot",            :default => 0
    t.integer  "busy",             :default => 0
    t.datetime "last_action_time", :default => '2014-11-10 08:41:08'
    t.string   "game_level",       :default => "短工"
    t.integer  "vip_level"
    t.float    "total_consume"
    t.integer  "robot_type"
    t.integer  "prize",            :default => 0
  end

  add_index "users", ["robot", "busy", "last_action_time"], :name => "available_robot"
  add_index "users", ["user_id"], :name => "index_users_on_user_id", :unique => true

  create_table "vip_counts", :force => true do |t|
    t.string   "vip_level"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "visit_room_counts", :force => true do |t|
    t.integer  "game_room_id"
    t.integer  "user_id"
    t.integer  "count"
    t.string   "date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "visit_ui_counts", :force => true do |t|
    t.integer  "ui_id"
    t.integer  "click_count"
    t.integer  "time_count"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
