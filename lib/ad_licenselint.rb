require 'optparse'
require 'logger'
require 'colorize'
require 'tempfile'
require 'json'
require 'terminal-table'
require 'cocoapods-core'
require 'json'

require 'ad_licenselint/ad_logger'
require 'ad_licenselint/option_handler'
require 'ad_licenselint/runner'
require 'ad_licenselint/license_entry'
require 'ad_licenselint/constant'

module ADLicenseLint
  class Error < StandardError; end

  LOGGER = ADLogger.new
end
