gem 'minitest'
require 'minitest/autorun'
require 'test_helper'
require 'yaml'

class TestHeaders < Minitest::Test

  def test_headers
    Dir.glob('**/*.erb') do |erb|
      extracted = IO.read(erb).match(/<%#(.+?).-?%>/m)
      refute_nil extracted
      yaml = YAML.load(extracted[1])
      refute_nil yaml
      refute_nil yaml['kind'], "#{erb} metadata does not contain kind attribute"
      refute_empty yaml['kind'], "#{erb} metadata kind attribute is empty"
      refute_nil yaml['name'], "#{erb} metadata does not contain name attribute"
      refute_empty yaml['name'], "#{erb} metadata name attribute is empty"
      refute_nil yaml['model'], "#{erb} metadata does not contain model attribute"
      refute_empty yaml['model'], "#{erb} metadata model attribute is empty"
    end
  end
end
