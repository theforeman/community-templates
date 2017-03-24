require 'erb'
require 'tempfile'
require 'nokogiri'

class PartitioningHelper
  attr_reader :disk_layout
  def initialize(family)
    @disk_layout = case family
                   when 'Redhat'
                     kickstart
                   when 'Debian'
                     preseed
                   when 'Suse'
                     autoyast
                   end
  end

  def kickstart
    part = <<-DL
      zerombr
      clearpart --all --initlabel
      part / --fstype=ext4 --size=1024 --grow
      part swap  --recommended
      DL
    part
  end

  def preseed
    ''
  end

  def autoyast
    ''
  end
end

class FakeStruct
  def initialize(hash)
    hash.each do |key, value|
      singleton_class.send(:define_method, key) { value }
    end
  end

  def get_binding
    binding
  end

  def to_s
    as_string
  end

  # Roughly equivalent to HostCommon#param_true?/false in Foreman core
  def param_true?(name)
    params[name] == 'true'
  end

  def param_false?(name)
    params[name] == 'false'
  end
end

class FakeNamespace
  attr_reader :root_pass, :grub_pass, :host
  def initialize(family, name, major, minor, release = nil)
    @mediapath = 'url --url http://localhost/repo/xyz'
    @root_pass = '$1$redhat$9yxjZID8FYVlQzHGhasqW/'
    @grub_pass = 'blah'
    @dynamic = false,
    @static = false,
    @host = FakeStruct.new(
      :operatingsystem => FakeStruct.new(
        :name => name,
        :family => family,
        :major => major,
        :minor => minor,
        :as_string => name,
        :release_name => release,
        :password_hash => 'SHA512'
      ),
      :name => 'hostname',
      :architecture => 'x86_64',
      :domain => 'example.com',
      :diskLayout => PartitioningHelper.new(family).disk_layout,
      :puppetmaster => 'http://localhost',
      :params => {
        'enable-puppetlabs-repo' => 'true'
      },
      :info => {
        'parameters' => { 'realm' => 'EXAMPLE.COM' }
      },
      :otp => 'onetimepassword',
      :realm => FakeStruct.new(
        :name => 'EXAMPLE.COM',
        :realm_type => 'FreeIPA',
        :as_string  => 'EXAMPLE.COM'
      ),
      :as_string => name,
      :subnet => FakeStruct.new(
        :dhcp_boot_mode? => true
      ),
      :mac => '00:00:00:00:00:01',
      :primary_interface => FakeStruct.new(
        :identifier => 'eth0',
        :subnet => FakeStruct.new(
          :dhcp_boot_mode? => true
        ),
      ),
     :managed_interfaces => [
       FakeStruct.new(
         :identifier => 'eth0',
         :managed? => true,
         :primary => true,
         :ip => '1.2.3.4',
         :subnet => FakeStruct.new(
           :dhcp_boot_mode? => true
         ),
       ),
     ]
    )
  end

  def snippet(*args)
    ''
  end

  def ks_console(*args)
    'console=ttyS99'
  end

  def foreman_url(*args)
    'http://localhost'
  end
end

module TemplatesHelper
  def render_erb(template, namespace)
    erb = ::ERB.new(IO.read(template), nil, '-')
    erb.filename = template
    erb.result(namespace.instance_eval { binding })
  end

  def ksvalidator(version, kickstart)
    ksvalidator_cmd = ENV['KSVALIDATOR'] || 'ksvalidator'
    output = `#{ksvalidator_cmd} -v #{version} #{kickstart}`
    [$?.to_i, output]
  end

  def debconfsetsel(preseed)
    debconfset_cmd = ENV['DEBCONFSETSEL'] || 'debconf-set-selections'
    output = `#{debconfset_cmd} --checkonly #{preseed}`
    [$?.to_i, output]
  end

  def autoyastvalidator(autoyast)
    xml = File.open(autoyast) { |f| Nokogiri::XML(f) }
    xml_errors = xml.errors
    [xml_errors.length, xml_errors]
  end

  def validate_erb(template, namespace, ksversion)
    t = Tempfile.new('community-templates-validate')
    t.write(render_erb(template, namespace))
    t.close
    case namespace.host.operatingsystem.family
    when 'Redhat'
      ksvalidator(ksversion, t.path)
    when 'Debian'
      debconfsetsel(t.path)
    when 'Suse'
      autoyastvalidator(t.path)
    end
  ensure
    t.unlink
  end
end

class String
  def blank?
    self !~ /[^[:space:]]/
  end
end
