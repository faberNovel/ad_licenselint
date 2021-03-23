$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'minitest/autorun'
require 'minitest/hooks/test'
require 'ad_licenselint'
require 'yaml'
require 'fileutils'

PODFILE_DIR = "test/TestLicenseCollector"
CONFIG_PATH = File.join(PODFILE_DIR, ".ad_licenselint.yml")

class TestCase < Minitest::Test
  include Minitest::Hooks
end

class ADLincenseLintTest < TestCase

  # from minitest-hooks
  def after_all
    install_pods(["Alamofire"])
  end

  def teardown
    FileUtils.rm CONFIG_PATH if File.exist? CONFIG_PATH
  end

  def test_one_valid_pod
    install_pods(["Alamofire"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      all: true
    }

    content = ADLicenseLint::Runner.new(options).run
    assert_includes content, "Alamofire"
    assert_includes content, "MIT"
  end

  def test_one_valid_pod_no_warning
    install_pods(["Alamofire"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      all: false
    }

    content = ADLicenseLint::Runner.new(options).run
    assert_empty content
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
      assert_includes content, "ObjectivePGP"
      assert_includes content, "BSD for non-commercial use"
    }
  end

  def test_one_invalid_pod_with_allowlist
    install_pods(["ObjectivePGP"])
    write_allowlist(["ObjectivePGP", "OtherPod"])

    [false, true].each { |all|
      options = {
        format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
        path: PODFILE_DIR,
        all: all
      }

      content = ADLicenseLint::Runner.new(options).run
      if all
        assert_includes content, "ObjectivePGP"
        assert_includes content, "BSD for non-commercial use"
      else
        refute_includes content, "ObjectivePGP"
        refute_includes content, "BSD for non-commercial use"
      end
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
    assert_includes content, "Alamofire"
    assert_includes content, "MIT"
    assert_includes content, "ObjectivePGP"
    assert_includes content, "BSD for non-commercial use"
  end

  def test_one_valid_one_invalid_pod_warning
    install_pods(["Alamofire", "ObjectivePGP"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      all: false
    }

    content = ADLicenseLint::Runner.new(options).run
    assert_includes content, "ObjectivePGP"
    assert_includes content, "BSD for non-commercial use"
    refute_includes content, "Alamofire"
    refute_includes content, "MIT"
  end

  def test_only_with_all
    install_pods(["Alamofire", "ObjectivePGP"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      only: ["Alamofire"],
      all: true
    }

    content = ADLicenseLint::Runner.new(options).run
    assert_includes content, "Alamofire"
    assert_includes content, "MIT"
    refute_includes content, "ObjectivePGP"
    refute_includes content, "BSD for non-commercial use"
  end

  def test_only_with_warnings
    install_pods(["Alamofire", "ObjectivePGP"])
    options = {
      format: ADLicenseLint::Constant::TERMINAL_FORMAT_OPTION,
      path: PODFILE_DIR,
      only: ["Alamofire"],
      all: false
    }

    content = ADLicenseLint::Runner.new(options).run
    assert_empty content
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

  def write_allowlist(pods)
    config = { "allow" => pods }
    File.write(CONFIG_PATH, config.to_yaml)
  end
end
