require 'erb'
require 'tempfile'

DISKLAYOUT = <<DL
zerombr
clearpart --all --initlabel
part / --fstype=ext4 --size=1024 --grow
part swap  --recommended
DL

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
end

class FakeNamespace
  attr_reader :root_pass, :grub_pass
  def initialize(family, name, major, minor)
    @mediapath = 'url --url http://localhost/repo/xyz'
    @root_pass = '$1$redhat$9yxjZID8FYVlQzHGhasqW/'
    @grub_pass = 'blah'
    @host = FakeStruct.new(
      :operatingsystem => FakeStruct.new(
        :name => name,
        :family => family,
        :major => major,
        :minor => minor,
        :as_string => name
      ),
      :architecture => 'x86_64',
      :diskLayout => DISKLAYOUT,
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
      :mac => '00:00:00:00:00:01'
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

  def validate_erb(template, namespace, ksversion)
    t = Tempfile.new('community-templates-validate')
    t.write(render_erb(template, namespace))
    t.close
    ksvalidator(ksversion, t.path)
  ensure
    t.unlink
  end

end

class String
  def blank?
    self !~ /[^[:space:]]/
  end
end
