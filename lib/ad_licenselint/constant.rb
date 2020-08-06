module ADLicenseLint
  module Constant
    MARKDOWN_FORMAT_OPTION = "md"
    TERMINAL_FORMAT_OPTION = "term"
    AVAILABLE_OPTIONS = [MARKDOWN_FORMAT_OPTION, TERMINAL_FORMAT_OPTION]
    ACCEPTED_LICENSES = ["MIT", "Apache", "Apache 2.0", "BSD"]
    DEFAULT_OPTIONS = {
      format: TERMINAL_FORMAT_OPTION,
      path: ".",
      all: false,
      only: nil
    }
  end
end
