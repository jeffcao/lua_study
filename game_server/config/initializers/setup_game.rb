require "logic/game_logic"
require "logic/synchronization"
#EM.next_tick do
#  Fiber.new {
#    DdzGameServer::Synchronization.synchronize!
#    EM.add_shutdown_hook { DdzGameServer::Synchronization.shutdown! }
#  }.resume
#end