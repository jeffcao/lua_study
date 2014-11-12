require "result_code"
require 'open-uri'
require "logic/game_logic"
require 'game_activity_effect/online_time_effect'
require 'game_teach_effect/game_teach_effect'
require "game_security/client_verify"

class ApplicationController < ActionController::Base
  protect_from_forgery
end
