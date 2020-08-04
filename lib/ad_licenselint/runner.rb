module ADLicenseLint

  class Runner
    attr_accessor :options

    POD_SOURCE = Pod::Source.new("~/.cocoapods/repos/master")

    def initialize(options = nil)
      @options = options || OptionHandler.parse
    end

    def run
      pods_support_files_path = File.join(File.expand_path(options[:path]), 'Pods', 'Target\ Support\ Files')
      raise "Folder #{pods_support_files_path} does not exist" if Dir[pods_support_files_path].empty?

      plist_files = Dir[File.join(pods_support_files_path, "Pods-*/*acknowledgements.plist")]

      json_contents = plist_files.map do |plist_file|
        tmp_file = Tempfile.new('license')
        system "plutil -convert json -o #{tmp_file.path} \"#{plist_file}\"" # convert plist to json
        result = JSON.parse(File.read(tmp_file.path))
        tmp_file.unlink # deletes the temp file
        result
      end

      pod_names = pod_names_from_podfile

      entries = json_contents
        .map { |json| json["PreferenceSpecifiers"].map { |hash| LicenseEntry.new hash } }
        .flatten
        .select(&:is_valid)
        .select { |e| pod_names.include?(e.title) }
        .uniq(&:title)

      entries.each { |e| e.source_url = source_url(e) }

      warning_entries = entries
        .select { |entry| !entry.is_accepted }

      displayed_entries = options[:all] ? entries : warning_entries

      case options[:format]
      when ADLicenseLint::Constant::MARKDOWN_FORMAT_OPTION
        markdown_entries(displayed_entries)
      when ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION
        terminal_entries(displayed_entries)
      end
    end

    private
    def terminal_entries(entries)
      rows = entries.map { |entry| [entry.title, entry.license, entry.source_url] }
      table = Terminal::Table.new({
        headings: ['Pod', 'License', 'Source'],
        rows: rows
      })
      table.to_s
    end

    def markdown_entries(entries)
      rows = [
        "| Pod | License | Source |",
        "| --- | --- | --- |",
      ] + entries.map { |entry|
        "| #{entry.title} | #{entry.license} | #{entry.source_url} |"
      }
      summary = rows.join("\n")

      details = entries.map { |entry|
        ["<details>",
         "<summary>#{entry.title}</summary>",
         "",
         "```",
         entry.footer_text,
         "```",
         "</details>"].join("\n")
       }.join("\n")

       return "#{summary}\n\n#{details}"
    end

    def source_url(entry)
      url = git_url(entry)
      return nil if url.nil?
      url.gsub(".git", "")
    end

    def git_url(entry)
      set = POD_SOURCE.set(entry.title)
      return nil if set.highest_version.nil?
      spec = set.specification.to_hash
      spec["source"]["git"] || spec["homepage"]
    end

    def pod_names_from_podfile
      path = File.join(File.expand_path(options[:path]), 'Podfile')
      Pod::Podfile.from_file(path).dependencies
        .map(&:name)
        .map { |e| e.split("/").first } # ex: convert CocoaLumberjack/Swift to CocoaLumberjack
        .uniq
    end
  end
end