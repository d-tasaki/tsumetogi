require 'tsumetogi'

module Tsumetogi
  class Logger
    def initialize(config = nil)
      if config
        @verbose = config.verbose
        @progress = config.progress
      end
      @fp = $stdout
    end

    def puts(message = nil)
      @fp.puts message
    end

    def debug(message)
      return unless @verbose
      @fp.puts message
    end

    def progress(message, processed_num, total_num)
      return unless @progress
      return if total_num == 0

      percent = (processed_num / total_num.to_f * 100).to_i
      done    = "=" * (      30 * percent / 100).to_i
      not_yet = "-" * (30 - (30 * percent / 100).to_i)
      msg = "#{message} : [%3d%%] |%s%s|" % [percent, done, not_yet]
      @fp.print "#{msg}\r"
      flush
    end

    def flush
      @fp.flush
    end
  end

  def self.logger=(new_logger)
    @logger = new_logger
  end

  def self.logger
    @logger ||= Logger.new
  end
end
