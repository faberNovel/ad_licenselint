module ADLicenseLint

  class Runner
    attr_accessor :options

    def initialize
      @options = OptionHandler.parse
    end

    def run(args = ARGV)
      LOGGER.log(:info, :green, "OPTIONS : #{options}")

      pods_support_files_path = File.join(File.expand_path(options.path), 'Pods', 'Target\ Support\ Files')
      raise "Folder #{pods_support_files_path} does not exist" if Dir[pods_support_files_path].empty?

      plist_files = Dir[File.join(pods_support_files_path, "Pods-*/*acknowledgements.plist")]

      json_contents = plist_files.map do |plist_file|
        tmp_file = Tempfile.new('license')
        system "plutil -convert json -o #{tmp_file.path} \"#{plist_file}\"" # convert plist to json
        result = JSON.parse(File.read(tmp_file.path))
        tmp_file.unlink # deletes the temp file
        result
      end

      entries = json_contents
        .map { |json| json["PreferenceSpecifiers"].map { |hash| LicenseEntry.new hash } }
        .flatten
        .select(&:is_valid)
        .uniq(&:title)

      warning_entries = entries
        .select { |entry| !entry.is_accepted }

      case options.format
      when ADLicenseLint::Constant::MARKDOWN_FORMAT_OPTION
        markdown_entries(warning_entries)
      when ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION
        terminal_entries(warning_entries)
      end
    end

    private
    def terminal_entries(entries)
      rows = entries.map { |entry| [entry.title, entry.license, entry.copyright] }
      table = Terminal::Table.new({
        headings: ['Pod', 'License', 'Copyright'],
        rows: rows
      })
      table.to_s
    end

    def markdown_entries(entries)
      rows = [
        "| Pod | License | Copyright |",
        "| --- | --- | --- |",
      ] + entries.map { |entry|
        "| #{entry.title} | #{entry.license} | #{entry.copyright} |"
      }
      rows.join("\n")
    end
  end
end