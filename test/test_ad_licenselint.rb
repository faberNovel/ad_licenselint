$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'minitest/autorun'
require 'minitest/hooks/test'
require 'ad_licenselint'

PODFILE_DIR = "test/TestLicenseCollector"

class TestCase < Minitest::Test
  include Minitest::Hooks
end

class ADLincenseLintTest < TestCase

  # from minitest-hooks
  def after_all
    install_pods(["Alamofire"])
  end

  def test_one_valid_pod
    install_pods(["Alamofire"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      all: true
    }

    content = ADLicenseLint::Runner.new(options).run
    assert content.include?("Alamofire")
    assert content.include?("MIT")
  end

  def test_one_valid_pod_no_warning
    install_pods(["Alamofire"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      all: false
    }

    content = ADLicenseLint::Runner.new(options).run
    assert_equal content, ""
  end

  def test_one_invalid_pod
    install_pods(["ObjectivePGP"])

    [false, true].each { |all|
      options = {
        format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
        path: PODFILE_DIR,
        all: all
      }

      content = ADLicenseLint::Runner.new(options).run
      assert content.include?("ObjectivePGP")
      assert content.include?("BSD for non-commercial use")
    }
  end

  def test_one_valid_one_invalid_pod
    install_pods(["Alamofire", "ObjectivePGP"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      all: true
    }

    content = ADLicenseLint::Runner.new(options).run
    assert content.include?("Alamofire")
    assert content.include?("MIT")
    assert content.include?("ObjectivePGP")
    assert content.include?("BSD for non-commercial use")
  end

  def test_one_valid_one_invalid_pod_warning
    install_pods(["Alamofire", "ObjectivePGP"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      all: false
    }

    content = ADLicenseLint::Runner.new(options).run
    assert content.include?("ObjectivePGP")
    assert content.include?("BSD for non-commercial use")
  end

  private
  def podfile_content(pods)
    pod_list = pods
      .map { |pod| "pod '#{pod}'" }
      .join("\n")

    return """platform :ios, '13.3'

target 'TestLicenseCollector' do
  use_frameworks!
  #{pod_list}

  target 'TestLicenseCollectorTests' do
    inherit! :search_paths
  end
end"""
  end

  def install_pods(pods)
    File.write(File.join(PODFILE_DIR, "Podfile"), podfile_content(pods))
    Dir.chdir(PODFILE_DIR) do
      system "bundle exec pod install > /dev/null"
    end
  end
end
