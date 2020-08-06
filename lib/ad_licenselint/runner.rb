module ADLicenseLint

  class Runner
    attr_accessor :options, :path

    POD_SOURCE = Pod::Source.new("~/.cocoapods/repos/master")

    def initialize(options = nil)
      if options.nil?
        @options = OptionHandler.parse
      else
        @options = ADLicenseLint::Constant::DEFAULT_OPTIONS.merge(options)
      end
      @path = File.expand_path(@options[:path])
    end

    def create_report
      raise "Folder #{target_support_path} does not exist" if Dir[target_support_path].empty?

      plist_files = Dir[acknowledgements_plist_path] # one plist for each target
      json_contents = plist_files.map { |plist_file| acknowledgement_json(plist_file) }
      entries = all_entries(json_contents)
      warning_entries = entries.reject(&:is_accepted)
      displayed_entries = options[:all] ? entries : warning_entries

      Report.new(displayed_entries)
    end

    def format(report)
      if report.empty?
        LOGGER.log(:info, :green, "No warnings found.")
        return ""
      end

      case options[:format]
      when ADLicenseLint::Constant::MARKDOWN_FORMAT_OPTION
        MarkdownFormatter.new(report).formatted_content
      when ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION
        TerminalFormatter.new(report).formatted_content
      end
    end

    def run
      format create_report
    end

    private

    def acknowledgement_json(plist_file)
      tmp_file = Tempfile.new('license')
      begin
        system "plutil -convert json -o #{tmp_file.path} \"#{plist_file}\"" # convert plist to json
        JSON.parse(File.read(tmp_file.path))
      ensure
        tmp_file.close
        tmp_file.unlink # deletes the temp file
      end
    end

    def all_entries(json_contents)
      pod_names = pod_names_from_podfile
      entries = json_contents
        .map { |json| json["PreferenceSpecifiers"].map { |hash| LicenseEntry.new hash } }
        .flatten
        .select(&:is_valid)
        .select { |e| pod_names.include?(e.pod_name) }
        .select { |e| options[:only].nil? ? true : options[:only].include?(e.pod_name) }
        .uniq(&:pod_name)
      entries.each { |e| e.source_url = source_url(e.pod_name) }
      entries
    end

    def source_url(pod_name)
      url = git_url(pod_name)
      url&.gsub(".git", "")
    end

    def git_url(pod_name)
      spec = pod_specification(pod_name)
      spec["source"]["git"] || spec["homepage"] unless spec.nil?
    end

    def pod_specification(pod_name)
      set = POD_SOURCE.set(pod_name)
      return nil if set.highest_version.nil? # access to specification crashes if highest_version is nil
      set.specification.to_hash
    end

    def pod_names_from_podfile
      Pod::Podfile.from_file(podfile_path).dependencies
        .map(&:name)
        .map { |e| e.split("/").first } # ex: convert CocoaLumberjack/Swift to CocoaLumberjack
        .uniq
    end

    def podfile_path
      File.join(@path, 'Podfile')
    end

    def target_support_path
      File.join(@path, 'Pods', 'Target\ Support\ Files')
    end

    def acknowledgements_plist_path
      File.join(target_support_path, "Pods-*/*acknowledgements.plist")
    end
  end
end