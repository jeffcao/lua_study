require "logic/synchronization"

class ZInitRedisSubscribe

  unless DdzGameServer::Synchronization.synchronizing?
    Fiber.new {
      DdzGameServer::Synchronization.synchronize!
      EM.add_shutdown_hook { DdzGameServer::Synchronization.shutdown! }
    }.resume
  end
end