gem 'minitest'
require 'minitest/autorun'
require 'test_helper'

class TestKickstartProvision < Minitest::Test
  include TemplatesHelper

  def validate_distro(template, family, name, major, minor, ksversion)
    ns = FakeNamespace.new(family, name, major, minor)
    code, output = validate_erb(template, ns, ksversion)
    assert_empty output
    assert_equal code, 0
  end

  def kickstart_path
    'provisioning_templates/provision/'
  end

  def test_fedora_15
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'Fedora', '15', '', 'F15')
  end

  def test_fedora_16
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'Fedora', '16', '', 'F16')
  end

  def test_fedora_17
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'Fedora', '17', '', 'F17')
  end

  def test_fedora_18
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'Fedora', '18', '', 'F18')
  end

  def test_fedora_19
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'Fedora', '19', '', 'F19')
  end

  def test_fedora_20
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'Fedora', '20', '', 'F20')
  end

  def test_centos_5
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'CentOS', '5', '0', 'RHEL5')
  end

  def test_centos_6
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'CentOS', '6', '0', 'RHEL6')
  end

  def test_centos_7
    validate_distro(kickstart_path + '/kickstart_default.erb', 'Redhat', 'CentOS', '7', '0', 'RHEL7')
  end

  def test_rhel_5
    validate_distro(kickstart_path + '/kickstart_rhel_default.erb', 'Redhat', 'RHEL', '5', '0', 'RHEL5')
  end

  def test_rhel_6
    validate_distro(kickstart_path + '/kickstart_rhel_default.erb', 'Redhat', 'RHEL', '6', '0', 'RHEL6')
  end

  def test_rhel_7
    validate_distro(kickstart_path + '/kickstart_rhel_default.erb', 'Redhat', 'RHEL', '7', '0', 'RHEL7')
  end
end
