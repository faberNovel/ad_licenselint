module ADLicenseLint

  class Runner
    attr_accessor :options, :path

    POD_SOURCE = Pod::Source.new("~/.cocoapods/repos/master")

    def initialize(options = nil)
      @options = options || OptionHandler.parse
      @path = File.expand_path(@options[:path])
    end

    def run
      raise "Folder #{target_support_path} does not exist" if Dir[target_support_path].empty?

      plist_files = Dir[acknowledgements_plist_path] # one plist for each target
      json_contents = plist_files.map { |plist_file| acknowledgement_json(plist_file) }
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