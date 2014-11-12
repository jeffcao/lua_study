require "game_security/client_verify"

class ApplicationController < ActionController::Base
  protect_from_forgery
end
