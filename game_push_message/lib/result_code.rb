require "game_config"
require "game_text"

class ResultCode
  include GameConfig
  include GameText

  SERVER_CONNECTIONS_COUNT_KEY = "message_server_connections_key"
end