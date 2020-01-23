require 'minitest/autorun'
require 'test_helper'

describe 'preseed_default.erb' do
  before do
    @renderer = TemplateRenderer.new('Debian', 'provisioning_templates/provision/preseed_default.erb')
  end

  {
    'Debian' => [
        ['7', '11', 'wheezy'],
        ['8', '6', 'jessie'],
        ['9', '4', 'stretch'],
    ],
    'Ubuntu' => [
        ['14', '04', 'trusty'],
        ['16', '04', 'xenial'],
        ['18', '04', 'bionic'],
    ],
  }.each do |distro, releases|
    releases.each do |major, minor, release|
      describe "#{distro} #{major}.#{minor} #{release}" do
        it 'will compile' do
          skip("debconf-set-selections not found, use DEBCONFSETSEL to set path to executable") unless @renderer.debian_validator_present?
          code, stdout, stderr = @renderer.render(distro, major, minor, release)
          _(stdout).must_equal ''
          _(stderr).must_equal ''
          _(code).must_equal 0
        end
      end
    end
  end
end
