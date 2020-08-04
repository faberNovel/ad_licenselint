module ADLicenseLint

  Options = Struct.new(:format, :path)

  class OptionHandler

    def self.parse

      options = Options.new

      available_formats = ADLicenseLint::Constant::AVAILABLE_OPTIONS

      parser = OptionParser.new do |p|
        p.banner = "Usage: ad_licenselint -f [md|term]"

        p.on("-f", "--format [FORMAT]", "Select output format (#{available_formats.join(", ")})") do |arg|
          options.format = arg
        end

        p.on("-p", "--path [PATH]", "Path of .xcworkspace") do |arg|
          options.path = arg
        end

        p.on("-h", "--help", "Prints this help") do
          puts p
          exit
        end
      end

      begin
        parser.parse!
        options.path = options.path || "."
        raise OptionParser::MissingArgument, "--format" if options.format.nil?
        raise OptionParser::InvalidArgument, "--format" unless available_formats.include?(options.format)
      rescue OptionParser::MissingArgument => e
        LOGGER.log(:error, :red, "Missing argument for option #{e.args.join(",")}")
        exit
      rescue OptionParser::InvalidArgument => e
        LOGGER.log(:error, :red, "Invalid argument for option #{e.args.join(",")}")
        exit
      rescue ArgumentError => e
        LOGGER.log(:error, :red, e.message)
        raise e
      end

      options
    end
  end
end