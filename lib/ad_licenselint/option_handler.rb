module ADLicenseLint

  class OptionHandler

    def self.parse

      options = {
        format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
        path: ".",
        all: false,
        only: nil
      }
      available_formats = ADLicenseLint::Constant::AVAILABLE_OPTIONS

      parser = OptionParser.new do |p|
        p.banner = "Usage: ad_licenselint -f [md|term]"

        p.on("-f", "--format [FORMAT]", "[Optional] Select output format [#{available_formats.join(", ")}] (default to #{options[:format]})") do |arg|
          options[:format] = arg
        end

        p.on("-p", "--path [PATH]", "[Optional] Sources directory (default to \"#{options[:path]}\")") do |arg|
          options[:path] = arg
        end

        p.on("-a", "--all", "[Optional] Display all licenses (default to #{options[:all]})") do |arg|
          options[:all] = true
        end

        p.on("-o", "--only [PODS]", Array, "[Optional] Display licenses for pods in argument. E.g -o Pod1,Pod2.") do |arg|
          options[:only] = arg
        end

        p.on("-h", "--help", "Prints this help") do
          puts p
          exit
        end
      end

      begin
        parser.parse!
        raise OptionParser::InvalidArgument, "--format" unless available_formats.include?(options[:format])
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