module ADLicenseLint
  class TerminalFormatter

    def initialize(report)
      @report = report
    end

    def formatted_content
      rows = @report.entries.map { |entry|
        [entry.pod_name, entry.license_name, entry.source_url]
      }
      table = Terminal::Table.new({
        headings: ['Pod', 'License', 'Source'],
        rows: rows
      })
      table.to_s
    end
  end
end