#encoding: utf-8
class DataForOaController < ApplicationController
   def get_data
     total_day_money = 0
     date = params[:date]
     record = DdzSheet.find_by_date(date)
     total_day_money = record.total_day_money unless record.nil?
     render :text=>total_day_money
   end
end
