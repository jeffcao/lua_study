#encoding: utf-8

class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column  :users, :game_level, :string, :default=>"短工"

  end
end
