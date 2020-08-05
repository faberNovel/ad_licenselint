module ADLicenseLint
  class MarkdownFormatter
    def initialize(report)
      @report = report
    end

    def formatted_content
      rows = [
        "| Pod | License | Source |",
        "| --- | --- | --- |",
      ] + @report.entries.map { |entry|
        "| #{entry.pod_name} | #{entry.license_name} | #{entry.source_url} |"
      }
      summary = rows.join("\n")

      details = @report.entries.map { |entry|
        ["<details>",
         "<summary>#{entry.pod_name}</summary>",
         "",
         "```",
         entry.license_content,
         "```",
         "</details>"].join("\n")
       }.join("\n")

       "#{summary}\n\n#{details}"
    end
  end
end