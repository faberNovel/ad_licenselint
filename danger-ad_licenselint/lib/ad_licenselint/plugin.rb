require 'ad_licenselint'
require 'cocoapods-core'

module Danger
  # Lint license from pods in your Podfile
  # This is done using the gem ad_licenselint
  #
  # You should replace these comments with a public description of your library.
  #
  # @example Specifying options
  #
  #          ad_licenselint.lint_licenses(inline_mode: true)
  #
  # @see  fabernovel/danger-ad_licenselint
  # @tags license, lint, podfile, cocoapods, ad_licenselint
  #
  class DangerAdLicenselint < Plugin

    # Provides additional logging diagnostic information
    #
    # @return  [Boolean]
    attr_accessor :verbose

    # Lints licenses from pods in Podfile.
    # Generates a `markdown` list of warnings either inline or globally.
    #
    # @param   [Boolean] inline_mode
    #          Create a review on the Podfile directly if set to true
    # @return  [void]
    #

    def lint_licenses(inline_mode: false)
      return if podfile_path.nil? || lockfile_path.nil?

      runner = ADLicenseLint::Runner.new({
        format: ADLicenseLint::Constant::MARKDOWN_FORMAT_OPTION,
        path: ".",
        all: false,
        only: get_modified_pods_from_diff
      })
      report = runner.create_report

      if inline_mode
        post_inline_messages(report)
      else
        post_global_message(runner.format(report))
      end
    end

    private

    def podfile_path
      git.modified_files.grep(/Podfile\z/).first
    end

    def lockfile_path
      git.modified_files.grep(/Podfile.lock\z/).first
    end

    def write_to_file(content)
      result = nil
      Tempfile.create { |f|
        f.write(content)
        f.rewind
        result = yield(f.path)
      }
      result
    end

    def line_for_content(subcontent, full_content)
      lines = full_content.split("\n")
      matching_line = nil
      lines.each_with_index { |line_content, index|
        matching_line = index if line_content.include?(subcontent)
      }
      matching_line + 1
    end

    def comment_for_report(report)
      comment = []
      comment << "*License linter*"
      comment << ""
      comment << "The license `#{report.license_name}` for the pod [#{report.pod_name}](#{report.source_url}) has not been automatically validated."
      comment << "Verify license below:"
      comment << "<details>"
      comment << "<summary>License</summary>"
      comment << ""
      comment << "```"
      comment << report.license_content
      comment << "```"
      comment << "</details>"
      comment.join("\n")
    end

    def get_modified_pods_from_diff
      after_podfile = write_to_file(git.info_for_file(podfile_path)[:after]) { |path|
        Pod::Podfile.from_file path
      }
      before_lockfile = write_to_file(git.info_for_file(lockfile_path)[:before]) { |path|
        Pod::Lockfile.from_file(Pathname(path))
      }
      changes = before_lockfile.detect_changes_with_podfile(after_podfile)
      changes[:added] + changes[:changed]
    end

    def post_inline_messages(report)
      podfile_content = git.info_for_file(podfile_path)[:after]
      report
        .entries
        .each { |pod_report|
          line = line_for_content(pod_report.pod_name, podfile_content)
          warn(
            comment_for_report(pod_report),
            file: podfile_path,
            line: line
          )
        }
    end

    def post_global_message(message)
      markdown(message)
    end

    def log(text)
      puts(text) if @verbose
    end

  end
end
