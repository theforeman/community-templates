require 'minitest/autorun'
require 'test_helper'

describe 'kickstart_default.erb' do
  before do
    @renderer = TemplateRenderer.new('Redhat', 'provisioning_templates/provision/kickstart_default.erb')
  end

  {
    'Fedora' => {
      prefix: 'F',
      majors: (15..29),
      minor: '',
    },
    'CentOS' => {
      prefix: 'RHEL',
      majors: (5..8),
      minor: '0',
    },
    'RHEL' => {
      prefix: 'RHEL',
      majors: (5..8),
      minor: '0',
    },
  }.each do |distro, options|
    options[:majors].each do |major|
      describe "#{distro} #{major}" do
        it 'will compile' do
          code, stdout, stderr = @renderer.render(distro, major, options[:minor], options[:prefix])
          stdout.must_equal ''
          stderr.must_equal ''
          code.must_equal 0
        end
      end
    end
  end
end
