gem 'minitest'
require 'minitest/autorun'
require 'test_helper'

class TestPreseedProvision < Minitest::Test
  include TemplatesHelper

  def validate_distro(template, family, name, major, minor, release)
    ns = FakeNamespace.new(family, name, major, minor, release)
    code, output = validate_erb(template, ns, '')
    assert_empty output
    assert_equal code, 0
  end

  def preseed_path
    'provisioning_templates/provision/'
  end

  def test_ubuntu_16_04
    validate_distro(preseed_path + '/preseed_default.erb', 'Debian', 'Ubuntu', '16', '04', 'xenial')
  end

  def test_ubuntu_14_04
    validate_distro(preseed_path + '/preseed_default.erb', 'Debian', 'Ubuntu', '14', '04', 'trusty')
  end

  def test_debian_8_6
    validate_distro(preseed_path + '/preseed_default.erb', 'Debian', 'Debian', '8', '6', 'jessie')
  end

  def test_debian_7_11
    validate_distro(preseed_path + '/preseed_default.erb', 'Debian', 'Debian', '7', '11', 'wheezy')
  end
end
