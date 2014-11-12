require "logic/synchronization"

class ZInitRedisSubscribe
  # To change this template use File | Settings | File Templates.Rails.logger.debug("[BaseController.initialize]")
  unless GamePushMessage::Synchronization.synchronizing?
    Rails.logger.debug("[BaseController.initialize synchronizing? is false]")
    Fiber.new {
      GamePushMessage::Synchronization.synchronize!
      EM.add_shutdown_hook { GamePushMessage::Synchronization.shutdown! }
    }.resume
  end
end