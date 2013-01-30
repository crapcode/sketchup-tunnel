module Tunnel
	PORT = 1517
  @@connected = false
  @@running_script = false
  @@log = Array.new
  def self.connected?; @@connected; end;
  def self.running_script?; @@running_script; end;
  def self.log;        @@log;       end;
  def self.connect
    if !@@connected
      @@connected = true
      SKSocket.connect "127.0.0.1", PORT
      SKSocket.add_socket_listener {|msg|
        if msg[0..4] == "LOAD:"
          begin
          	path = msg[5..-1]
          	dirname = File.dirname(path)
          	$LOAD_PATH.push(dirname).compact!
          	@@running_script = true
            load path
            @@running_script = false
            SKSocket.write Tunnel.log.join
          rescue Exception => e
          	@@running_script = false
            SKSocket.write Tunnel.log.join + e.message + "\n" + e.backtrace[0..-3].join("\n")
          end
          Tunnel.log.clear
        end
        if msg != "Connection established"
          SKSocket.disconnect
          @@connected = false
        end
      }
    end
  end
end

UI.start_timer(1.4, true) {
  Tunnel.connect
}

def puts(input = String.new)
  if Tunnel.running_script?
    Tunnel.log.push "#{input}\n"
    nil
  else
    super
  end
end