module ADLicenseLint
  class MarkdownFormatter
    def initialize(report)
      @entries = report.entries.sort_by(&:pod_name)
    end

    def formatted_content
      "#{table}\n\n#{foldable_content}"
    end

    private

    def table
      rows = [
        "| Pod | License | Source |",
        "| --- | --- | --- |",
      ] + @entries.map { |entry|
        "| #{entry.pod_name} | #{entry.license_name} | #{entry.source_url} |"
      }
      rows.join("\n")
    end

    def foldable_content
      [
        "<details>",
        "<summary>Licenses</summary>",
        "",
        licenses_content,
        "</details>"
      ].join("\n")
    end

    def licenses_content
      @entries
        .map { |entry|
          [
            "### #{entry.pod_name}",
            "```",
            entry.license_content,
            "```",
          ].join("\n")
        }
        .join("\n")
    end
  end
end