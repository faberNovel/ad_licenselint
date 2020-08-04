module ADLicenseLint
  class ADLogger
    SEVERITY = { debug: Logger::DEBUG , info: Logger::INFO, warn: Logger::WARN, error: Logger::ERROR, fatal: Logger::FATAL, unknown: Logger::UNKNOWN }
    AUTHORIZED_COLORS  = [:black, :yellow, :red, :blue, :green]

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    def log(level, color, text)
      exit unless text and level and color

      level, color = [level, color].map(&:to_sym)
      raise "Color not supported" unless AUTHORIZED_COLORS.include? color
      raise "Invalid severity" unless SEVERITY.dig(level)

      @logger.add(SEVERITY.dig(level), text.send(color))
    end

    def debug!
      @logger.level = Logger::DEBUG
    end

    def debug?
      @logger.debug?
    end

    def close
      @logger.close
    end
  end
end