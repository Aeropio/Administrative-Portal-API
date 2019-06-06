module Utils
  class LogUtil
    def self.get(file_path)
      log_file_path = file_path
      if File.exist? log_file_path
        log_file = File.new(log_file_path, File::WRONLY | File::APPEND)
      else
        log_file = File.new(log_file_path, File::WRONLY | File::APPEND | File::CREAT)
      end

      @logger = Utils::AppLogger.new(log_file)
    end
  end
end