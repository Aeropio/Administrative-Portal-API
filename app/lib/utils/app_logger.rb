require 'rubygems'
require 'logger'

module Utils
  class AppLogger < Logger
    def info(msg)
      puts "[INFO] " + msg if STDOUT
      super(msg)
    rescue Exception => e
      e.backtrace
    end

    def fatal(msg)
      puts "[FATAL] " + msg if STDOUT
      super(msg)
    rescue Exception => e
      e.backtrace
    end

    def error(msg)
      puts "[ERROR] " + msg if STDOUT
      super(msg)
    rescue Exception => e
      e.backtrace
    end

    def debug(msg)
      puts "[DEBUG] " + msg if STDOUT
      super(msg)
    rescue Exception => e
      e.backtrace
    end
  end
end