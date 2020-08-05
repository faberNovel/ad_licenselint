module ADLicenseLint
  class TerminalFormatter

    def initialize(report)
      @report = report
    end

    def formatted_content
      rows = @report
        .entries
        .sort_by(&:pod_name)
        .map { |entry|
          [entry.pod_name, entry.license_name, entry.source_url]
        }
      Terminal::Table.new({
        headings: ['Pod', 'License', 'Source'],
        rows: rows
      }).to_s
    end
  end
end