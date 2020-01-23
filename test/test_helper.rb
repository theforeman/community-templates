require 'open3'
require 'erb'
require 'tempfile'
require 'nokogiri'
require 'ostruct'
require 'active_support/all'

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

class FakeStruct < OpenStruct
  def to_s
    name || as_string
  end
end

class FakeNamespace
  attr_reader :root_pass, :grub_pass, :host

  def initialize(family, name, major, minor, release, ipv4_subnet, ipv6_subnet, vlan_tag, nic_type)
    @mediapath = 'url --url http://localhost/repo/xyz'
    @additional_media = []
    @root_pass = '$1$redhat$9yxjZID8FYVlQzHGhasqW/'
    @grub_pass = '--password=blah'
    @dynamic = false
    @static = false
    @static6 = false
    @kernel = "boot/a_vmlinuz"
    @initrd = "boot/an_initrd.img"
    @preseed_server = 'example.com:80'
    @preseed_path = '/bla'
    subnet4 = FakeStruct.new(
      :address => "192.168.1.0",
      :mask => "255.255.255.0",
      :gateway => "192.168.1.1",
      :dns_servers => ["192.168.1.254", "192.168.1.253"],
      :dhcp_boot_mode? => (ipv4_subnet == :dhcp),
      :nic_delay? => nil,
      :nic_delay => nil,
      :mtu => 1496
    )
    subnet6 = FakeStruct.new(
      :address => "2001:db8:cafe:babe::",
      :mask => "ffff:ffff:ffff:ffff::",
      :cidr => 64,
      :gateway => "2001:db8:cafe:babe::21",
      :dns_servers => ["2001:db8:cafe:babe::13", "2001:db8:cafe:babe::15"],
      :dhcp_boot_mode? => (ipv6_subnet == :dhcp),
      :nic_delay? => nil,
      :nic_delay => nil,
      :mtu => 1500
    )
    @nic1 = FakeStruct.new(
      :type => nic_type,
      :mac => '00:00:00:00:00:01',
      :identifier => 'eth0',
      :managed? => true,
      :primary => true,
      :ip => '1.2.3.4',
      :ip6 => "2001:db8:cafe:babe::7",
      :subnet => subnet4,
      :subnet6 => subnet6,
      :tag => vlan_tag,
      :attached_to => '',
      :inheriting_mac => nil,
      :attached_devices_identifiers => "em1,em2",
      :mode => "active-backup,balance-rr",
      :bond_options => "primary=em1 secondary=em2"
    )
    @identifier = @nic1.identifier
    @interface = @nic1
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
      :subnet => subnet4,
      :subnet6 => subnet6,
      :mac => '00:00:00:00:00:01',
      :ip => @nic1.ip,
      :ip6 => @nic1.ip6,
      :primary_interface => @nic1,
      :provision_interface => @nic1,
      :managed_interfaces => [@nic1],
      :bond_interfaces => [],
      :puppet_ca_server => ''
    )
    if ipv4_subnet == :none
      @nic1.subnet = nil
      @host.subnet = nil
    end
    if ipv6_subnet == :none
      @nic1.subnet6 = nil
      @host.subnet6 = nil
    end
    @host
  end

  def get_binding
    binding
  end

  def plugin_present?(name)
    false
  end

  def host_enc
    @host.info
  end

  def host_param(name)
    @host.params[name]
  end

  def host_param_true?(name)
    host_param(name) == 'true'
  end

  def host_param_false?(name)
    host_param(name) == 'false'
  end

  def snippet(*args)
    ''
  end

  def snippet_if_exists(*args)
    ''
  end

  def template_name
    'template name'
  end

  def ks_console(*args)
    'console=ttyS99'
  end

  def foreman_url(*args)
    'http://localhost'
  end

  def indent(_, _)
    yield
  end

  def pxe_kernel_options
    ''
  end

  def save_to_file(*args)
  end
end

module TemplatesHelper
  def render_erb(template, namespace)
    if RUBY_VERSION >= "2.6"
      erb = ::ERB.new(IO.read(template), trim_mode: '-')
    else
      erb = ::ERB.new(IO.read(template), nil, '-')
    end
    erb.filename = template
    erb.result(namespace.get_binding)
  end

  def ksvalidator(version, kickstart)
    return 0, '', '', '' unless @ksvalidator_cmd
    stdout, stderr, status = Open3.capture3("#{@ksvalidator_cmd} -v #{version} #{kickstart}")
    [status, stdout, stderr]
  end

  def debconfsetsel(preseed)
    return 0, '', '', '' unless @debconfset_cmd
    stdout, stderr, status = Open3.capture3("#{@debconfset_cmd} --checkonly #{preseed}")
    [status, stdout, stderr]
  end

  def autoyastvalidator(autoyast)
    xml = File.open(autoyast) { |f| Nokogiri::XML(f) }
    xml_errors = xml.errors
    [xml_errors.length, '', xml_errors]
  end

  def validate_erb(template, namespace, ksversion, validate = true)
    t = Tempfile.new('community-templates-validate')
    t.write(render_erb(template, namespace))
    t.close
    return 0, '', '' unless validate
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

class TemplateRenderer
  include TemplatesHelper

  def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each do |ext|
        exe = File.join(path, "#{cmd}#{ext}")
        return exe if File.executable?(exe) && !File.directory?(exe)
      end
    end
    nil
  end

  def initialize(osfamily, template)
    @osfamily = osfamily
    @template = template
    @ksvalidator_cmd = ENV['KSVALIDATOR'] || 'ksvalidator'
    @debconfset_cmd = ENV['DEBCONFSETSEL'] || "debconf-set-selections"
    @ksvalidator_cmd = nil unless which(@ksvalidator_cmd)
    @debconfset_cmd = nil unless which(@debconfset_cmd)
  end

  def redhat_validator_present?
    !!@ksvalidator_cmd
  end

  def debian_validator_present?
    !!@debconfset_cmd
  end

  def render(distro, major, minor, distro_prefix = '', release = nil, validate = true, ipv4_subnet = :dhcp, ipv6_subnet = :none, vlan = '', nic_type = "Nic::Managed")
    ns = FakeNamespace.new(@osfamily, distro, major, minor, release, ipv4_subnet, ipv6_subnet, vlan, nic_type)
    validate_erb(@template, ns, "#{distro_prefix}#{major}", validate)
  end
end
