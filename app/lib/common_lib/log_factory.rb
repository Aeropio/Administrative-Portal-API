#  @brief  Log factory gives sure singleton logger instance.

module CommonLib
  include Utils
  module LogFactory
    class SingletonLogger
      @@singleton_logger_instance = nil
      @@singleton_mutex = Mutex.new

      @@singleton_error_logger_instance = nil
      @@singleton_error_mutex = Mutex.new

      # Logger factory method method gives sure singleton logger instance.
      def self.get_logger_instance
        return @@singleton_logger_instance if @@singleton_logger_instance
        @@singleton_mutex.synchronize {
          return @@singleton_logger_instance if @@singleton_logger_instance

          # Log file location in server
          @@singleton_logger_instance = Utils::LogUtil.get("#{Rails.root}/log/gst.log")
        }
        @@singleton_logger_instance
      end

      # Logger factory method method gives sure singleton logger instance.
      def self.get_error_logger_instance
        return @@singleton_error_logger_instance if @@singleton_error_logger_instance
        @@singleton_error_mutex.synchronize {
          return @@singleton_error_logger_instance if @@singleton_error_logger_instance
          @@singleton_error_logger_instance = Utils::LogUtil.get("#{Rails.root}/log/gst_erros.log")
        }
        @@singleton_error_logger_instance
      end

      private
      # Private constructor for SingletonLogger class
      def initialize
  #      Utils::LogUtil.get("#{Rails.root}/log/active_fam.log")
      end
    end
  end
end