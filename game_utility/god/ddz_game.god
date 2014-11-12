# == God config file
# http://god.rubyforge.org/
# Authors: Gump and michael@glauche.de
#
# Config file for god that configures watches for each instance of a thin server for
# each thin configuration file found in /etc/thin.
# In order to get it working on Ubuntu, I had to make a change to god as noted at
# the following blog:
# http://blog.alexgirard.com/ruby-one-line-to-save-god/
#
require 'yaml'
require 'tlsmail'

config_path = "/data/local/game/ddz_server/0502002/config/god"

Dir[config_path + "/*.yml"].each do |file|
  config = YAML.load_file(file)
  num_servers = config["servers"] ||= 1

  (0...num_servers).each do |i|
    # UNIX socket cluster use number 0 to 2 (for 3 servers)
    # and tcp cluster use port number 3000 to 3002.
    number = config['socket'] ? i : (config['port'] + i)
    
      God.contact(:email) do |c|
        c.name = 'me'
        c.group = 'developers'
        #c.to_email = 'ddz.game.2013@gmail.com'
        c.to_email = 'jeffcao@cn6000.com'
      end
      God.contact(:email) do |c|
        c.name = 'edward'
        c.group = 'developers'
        c.to_email = 'edwardzhou@cn6000.com'
      end
   God.watch do |w|
      God::Contacts::Email.defaults do |d|
        d.from_email = 'ddz.game.2013@gmail.com'
        d.from_name = 'Process monitoring'
        d.delivery_method = :smtp
        d.server_host = 'smtp.gmail.com'
        d.server_port = 25
        d.server_auth = :login
        d.server_domain = 'domain.com'
        d.server_user = 'ddz.game.2013@gmail.com'
        d.server_password = 'ddz123456'
        Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
      end
      
      
      w.group = "thin-" + File.basename(file, ".yml")
      p "group is:" + w.group
      w.name = w.group + "-#{number}"
      p "name is:" + w.name
      w.interval = 30.seconds
      
      #w.uid = config["user"]
      #w.gid = config["group"]
      
      w.start = "thin start -C #{file} -o #{number}"
      w.start_grace = 10.seconds
      p "start command:" + w.start
      w.stop = "thin stop -C #{file} -o #{number}"
      w.stop_grace = 10.seconds
      
      w.restart = "thin restart -C #{file} -o #{number}"

      pid_path = config["chdir"] + "/" + config["pid"]
      p "pid_path: " + pid_path
      ext = File.extname(pid_path)

      w.pid_file = pid_path.gsub(/#{ext}$/, ".#{number}#{ext}")
      
      w.behavior(:clean_pid_file)

      w.start_if do |start|
        start.condition(:process_running) do |c|
          c.interval = 5.seconds
          c.running = false
          c.notify = {:contacts => ['me','edward'], :priority => 1, :category => 'product'}
        end
      end

      w.restart_if do |restart|
        restart.condition(:memory_usage) do |c|
          c.above = 150.megabytes
          c.times = [3,5] # 3 out of 5 intervals
        end

        restart.condition(:cpu_usage) do |c|
          c.above = 50.percent
          c.times = 5
        end
      end

      w.lifecycle do |on|
        on.condition(:flapping) do |c|
          c.to_state = [:start, :restart]
          c.times = 5
          c.within = 5.minutes
          c.transition = :unmonitored
          c.retry_in = 10.minutes
          c.retry_times = 5
          c.retry_within = 2.hours
        end
      end
    end
  end
end
