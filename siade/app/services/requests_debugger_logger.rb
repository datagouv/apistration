require 'json'
require 'singleton'

class RequestsDebuggerLogger
  include Singleton

  def initialize
    super
    create_logger_file
    logger.formatter = formatter
  end

  def log(params)
    logger.info(params)
  end

  private

  def create_logger_file
    FileUtils.touch(logger_path) unless File.exist?(logger_path)
  end

  def logger
    @logger ||= Logger.new(logger_path, 0, 1.gigabyte)
  end

  def logger_path
    Rails.root.join('log/requests_debugger.log')
  end

  def formatter
    proc do |_severity, datetime, _progname, params|
      params.merge({
        datetime:
      }).to_json << "\n"
    end
  end
end
