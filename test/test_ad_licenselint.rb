$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'minitest/autorun'
require 'ad_licenselint'

class ADLincenseLintTest < Minitest::Test
  def test_english_hello
    assert_equal "1", "1"
  end
end
