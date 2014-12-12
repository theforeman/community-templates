gem 'minitest'
require 'minitest/autorun'
require 'test_helper'
require 'yaml'

class TestHeaders < MiniTest::Unit::TestCase

  def test_headers
    Dir.glob('**/*.erb') do |erb|
      extracted = IO.read(erb).match(/<%#(.+?).-?%>/m)
      refute_nil extracted
      yaml = YAML.load(extracted[1])
      refute_nil yaml
      refute_nil yaml['kind']
      refute_empty yaml['kind']
      refute_nil yaml['name']
      refute_empty yaml['name']
    end
  end
end
