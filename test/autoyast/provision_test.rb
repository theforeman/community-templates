require 'minitest/autorun'
require 'test_helper'

class TestAutoyastProvision < Minitest::Test
  include TemplatesHelper

  def validate_distro(template, family, name, major, minor)
    ns = FakeNamespace.new(family, name, major, minor, nil, :dhcp, :none, nil, "Nic::Managed")
    code, stdout, stderr = validate_erb(template, ns, '')
    assert_empty stdout
    assert_empty stderr
    assert_equal code, 0
  end

  def autoyast_path
    'provisioning_templates/provision/'
  end

  def test_opensuse_42_2
    validate_distro(autoyast_path + '/autoyast_default.erb', 'Suse', 'OpenSuSE', '42', '2')
  end

  def test_sles_12_2
    validate_distro(autoyast_path + '/autoyast_sles_default.erb', 'Suse', 'SLES', '12', '2')
  end
end
