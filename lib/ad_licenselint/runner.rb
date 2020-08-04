module ADLicenseLint

  class Runner
    attr_accessor :options

    POD_SOURCE = Pod::Source.new("~/.cocoapods/repos/master")

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

      entries.each { |e| e.update_source_url(source_url(e)) }

      warning_entries = entries
        .select { |entry| !entry.is_accepted }

      displayed_entries = options.all ? entries : warning_entries

      case options.format
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
      set.specification.to_hash["source"]["git"]
    end
  end
end