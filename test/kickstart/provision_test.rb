require 'minitest/autorun'
require 'test_helper'

describe 'kickstart_default.erb' do
  before do
    @renderer = TemplateRenderer.new('Redhat', 'provisioning_templates/provision/kickstart_default.erb')
  end

  {
    'Fedora' => {
      prefix: 'F',
      majors: (27..30),
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
          skip("ksvalidator not found, use KSVALIDATOR to set path to executable") unless @renderer.redhat_validator_present?
          code, stdout, stderr = @renderer.render(distro, major, options[:minor], options[:prefix])
          _(stdout).must_equal ''
          _(stderr).must_equal ''
          _(code).must_equal 0
        end
      end
    end
  end
end

describe 'kickstart_default_pxelinux.erb' do
  before do
    @renderer = TemplateRenderer.new('Redhat', 'provisioning_templates/PXELinux/kickstart_default_pxelinux.erb')
  end

  {
    'Fedora' => {
      prefix: 'F',
      majors: (27..30),
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
          code, stdout, stderr = @renderer.render(distro, major, options[:minor], options[:prefix], nil, false)
          _(stdout).must_equal ''
          _(stderr).must_equal ''
          _(code).must_equal 0
        end
      end
    end
  end
end
