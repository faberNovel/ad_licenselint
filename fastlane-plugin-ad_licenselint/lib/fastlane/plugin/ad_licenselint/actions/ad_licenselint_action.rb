require 'fastlane/action'
require_relative '../helper/ad_licenselint_helper'
require 'ad_licenselint'

module Fastlane
  module Actions
    module SharedValues
      AD_LICENSE_LINT_REPORT = :AD_LICENSE_LINT_REPORT
      AD_LICENSE_LINT_SUMMARY = :AD_LICENSE_LINT_SUMMARY
    end

    class AdLicenselintAction < Action
      def self.run(params)
        runner = ADLicenseLint::Runner.new({
          format: params[:format],
          path: params[:path],
          all: params[:all],
          only: params[:only]
        })
        report = runner.create_report
        Actions.lane_context[SharedValues::AD_LICENSE_LINT_REPORT] = report.to_hash
        Actions.lane_context[SharedValues::AD_LICENSE_LINT_SUMMARY] = runner.format(report)
      end

      def self.description
        "Lint the licenses for iOS projects"
      end

      def self.authors
        ["Pierre Felgines"]
      end

      def self.return_value
        [
          "A string that displays licenses with warnings"
        ].join("\n")
      end

      def self.details
        "Lint the licenses for iOS projects"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :format,
                                  env_name: "AD_LICENSE_LINT_FORMAT",
                               description: "The format of the output (#{ADLicenseLint::Constant::AVAILABLE_OPTIONS})",
                                  optional: true,
                             default_value: ADLicenseLint::Constant::MARKDOWN_FORMAT_OPTION,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :path,
                                  env_name: "AD_LICENSE_LINT_PATH",
                               description: "The path of the directory that contains the Podfile",
                                  optional: true,
                             default_value: ".",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :all,
                                  env_name: "AD_LICENSE_LINT_FORMAT",
                               description: "Display all the licenses",
                                  optional: true,
                             default_value: false,
                                 is_string: false),
          FastlaneCore::ConfigItem.new(key: :only,
                                  env_name: "AD_LICENSE_LINT_FORMAT",
                               description: "Subset of pods",
                                  optional: true,
                                      type: Array),
        ]
      end

      def self.output
        [
          ['AD_LICENSE_LINT_REPORT', 'Hash representation of the report'],
          ['AD_LICENSE_LINT_SUMMARY', 'Formatted string of the result']
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
