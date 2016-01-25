require 'spec_helper'
require 'fakefs/safe'

describe 'puppet-retrospec' do
  after :all do
    # enabling the removal slows down tests, but from time to time we may need to
    FileUtils.rm_rf(fixture_modules_path) if ENV['RETROSPEC_CLEAN_UP_TEST_MODULES'] =~ /true/
  end

  let(:template_dir) do
    retrospec_templates_path
  end

  let(:global_config) do
    { 'author' => 'Corey Osman' }
  end

  let(:plugin_config) do
    {
      # 'plugins::puppet::template_dir' => '/Users',
      # 'plugins::puppet::templates::url' => '',
      # 'plugins::puppet::templates::ref'  => '',
      # 'plugins::puppet::enable_future_parser' => '',
      # 'plugins::puppet::enable_beaker_tests' => '',
      # 'plugins::puppet::namespace' => '',
      # 'plugins::puppet::auto_create' => '',
    }
  end

  let(:global_opts) do
    { :module_path => File.join(fixture_modules_path, 'tomcat') }
  end

  let(:plugin_opts) do
    {}
  end

  before :all do
    # enabling the removal of real modules slows down tests, but from time to time we may need to
    FileUtils.rm_rf(fixture_modules_path) if ENV['RETROSPEC_CLEAN_UP_TEST_MODULES'] =~ /true/
    install_module('puppetlabs-tomcat')
    @path = File.join(fixture_modules_path, 'tomcat')
  end

  before :each do
    clean_up_spec_dir(@path)
    @opts = { :module_path => @path, :enable_beaker_tests => false, :name => 'name-test123',
              :enable_user_templates => false, :template_dir => template_dir }
  end

  it 'should run without errors using new' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    expect(tomcat).to be_instance_of(Retrospec::Plugins::V1::Puppet)
  end

  it 'should set the parser to future' do
    opts = { :module_path => @path, :enable_beaker_tests => false,
             :enable_user_templates => false, :template_dir => nil, :enable_future_parser => true }
    tomcat = Retrospec::Plugins::V1::Puppet.new(opts[:module_path], opts)
    tomcat.post_init
    expect(tomcat.context.instance.future_parser).to eq(true)
  end

  it 'should create files without error' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    tomcat.create_files
    expect(File.exist?(File.join(@path, 'Gemfile'))).to eq(true)
    expect(File.exist?(File.join(@path, 'Rakefile'))).to eq(true)
    expect(File.exist?(File.join(@path, 'spec', 'spec_helper.rb'))).to eq(true)
    expect(File.exist?(File.join(@path, '.travis.yml'))).to eq(true)
    expect(File.exist?(File.join(@path, 'spec', 'shared_contexts.rb'))).to eq(true)
    expect(File.exist?(File.join(@path, '.fixtures.yml'))).to eq(true)
    expect(File.exist?(File.join(@path, 'spec', 'classes', 'tomcat_spec.rb'))).to eq(true)
  end

  it 'should create acceptance test files' do
    @opts[:enable_beaker_tests] = true
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    spec_path = File.expand_path(File.join(@path, 'spec'))
    tomcat.create_files
    expect(File.exist?(File.join(spec_path, 'spec_helper_acceptance.rb'))).to eq(true)
    expect(File.exist?(File.join(spec_path, 'acceptance'))).to eq(true)
    expect(File.exist?(File.join(spec_path, 'acceptance', 'classes', 'tomcat_spec.rb'))).to eq(true)
    expect(File.exist?(File.join(spec_path, 'acceptance', 'nodesets'))).to eq(true)
    expect(File.exist?(File.join(spec_path, 'acceptance', 'nodesets', 'default.yml'))).to eq(true)
  end

  it 'should not create acceptance test files' do
    clean_up_spec_dir(@path)
    @opts[:enable_beaker_tests] = false
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    spec_path = File.expand_path(File.join(@path, 'spec'))
    tomcat.create_files
    expect(File.exist?(File.join(spec_path, 'spec_helper_acceptance.rb'))).to eq(false)
    expect(File.exist?(File.join(spec_path, 'acceptance'))).to eq(true)
    expect(File.exist?(File.join(spec_path, 'acceptance', 'classes', 'tomcat_spec.rb'))).to eq(false)
    expect(File.exist?(File.join(spec_path, 'acceptance', 'nodesets'))).to eq(false)
    expect(File.exist?(File.join(spec_path, 'acceptance', 'nodesets', 'default.yml'))).to eq(false)
  end

  it 'should create proper spec helper file' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    filepath = File.expand_path(File.join(@path, 'spec', 'spec_helper.rb'))
    tomcat.safe_create_module_files
    path = tomcat.module_path
    expect(File.exist?(filepath)).to eq(true)
  end

  it 'should create proper shared context file' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    filepath = File.expand_path(File.join(@path, 'spec', 'shared_contexts.rb'))
    tomcat.safe_create_module_files
    expect(File.exist?(filepath)).to eq(true)
  end

  it 'should produce hiera data' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    filepath = File.expand_path(File.join(@path, 'spec', 'shared_contexts.rb'))
    tomcat.safe_create_module_files
    path = tomcat.module_path
    expect(tomcat.context.all_hiera_data).to eq('tomcat::catalina_home' => nil,
                                                'tomcat::user' => nil,
                                                'tomcat::group' => nil,
                                                'tomcat::install_from_source' => nil,
                                                'tomcat::purge_connectors' => nil,
                                                'tomcat::purge_realms' => nil,
                                                'tomcat::manage_user' => nil,
                                                'tomcat::manage_group' => nil
                                               )

    expect(File.read(filepath)).to include('#"tomcat::catalina_home" => \'\',')
  end

  it 'should create acceptance spec helper file' do
    opts = { :module_path => @path, :enable_beaker_tests => true,
             :template_dir => template_dir }
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], opts)
    tomcat.post_init
    filepath = File.expand_path(File.join(@path, 'spec', 'spec_helper_acceptance.rb'))
    tomcat.safe_create_module_files
    expect(File.exist?(filepath)).to eq(true)
  end

  it 'should not create acceptance spec helper file' do
    opts = { :module_path => @path, :enable_beaker_tests => false,
             :template_dir => template_dir }
    filepath = File.expand_path(File.join(@path, 'spec', 'spec_helper_acceptance.rb'))
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], opts)
    tomcat.post_init
    tomcat.safe_create_module_files
    expect(File.exist?(filepath)).to eq(false)
  end

  it 'should create 15 nodesets' do
    opts = { :module_path => @path, :enable_beaker_tests => true,
             :template_dir => template_dir }
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], opts)
    tomcat.post_init
    filepath = File.expand_path(File.join(@path, 'spec', 'acceptance', 'nodesets', 'default.yml'))
    tomcat.safe_create_module_files
    expect(File.exist?(filepath)).to eq(true)
    expect(Dir.glob(File.expand_path(File.join(@path, 'spec', 'acceptance', 'nodesets', '*.yml'))).length).to eq 15
  end

  it 'should create Gemfile file' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    filepath = File.expand_path(File.join(@path, 'Gemfile'))
    tomcat.safe_create_module_files
    expect(File.exist?(filepath)).to eq(true)
  end

  it 'should create Rakefile file' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    filepath = File.expand_path(File.join(@path, 'Rakefile'))
    tomcat.safe_create_module_files
    expect(File.exist?(filepath)).to eq(true)
  end

  it 'should create proper fixtures file' do
    filepath = File.expand_path(File.join(@path, '.fixtures.yml'))
    FileUtils.rm_f(filepath) # ensure we have a clean state
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    tomcat.safe_create_module_files
    expect(File.exist?(filepath)).to eq(true)
  end

  it 'should not create any files when 0 resources exists' do
    my_path = File.expand_path(File.join('spec', 'fixtures', 'fixture_modules', 'zero_resource_module'))
    my_retro = Retrospec::Plugins::V1::Puppet.new(my_path, @opts)
    my_retro.should_not_receive(:safe_create_file).with(anything, 'resource_spec_file.erb')
  end

  it 'should create a file from a template' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    tomcat.post_init
    file_path = File.join(@path, '.fixtures.yml')
    template_file = File.join(tomcat.template_dir, 'module_files', '.fixtures.yml.retrospec.erb')
    tomcat.safe_create_template_file(file_path, template_file, tomcat.context)
    expect(File.exist?(file_path)).to eq(true)
  end

  describe 'generate_file_path' do
    describe 'classes' do
      it 'should generate a acceptance test path correctly' do
        type = double('type')
        allow(type).to receive(:type).and_return(:hostclass)
        allow(type).to receive(:name).and_return('tomcat::config::server::connector')
        tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
        expect(tomcat.generate_file_path(type, true)).to eq('spec/acceptance/classes/config/server/connector_spec.rb')
      end
      it 'should generate a normal test path correctly' do
        type = double('type')
        allow(type).to receive(:type).and_return(:hostclass)
        allow(type).to receive(:name).and_return('tomcat::config::server::connector')
        tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
        expect(tomcat.generate_file_path(type, false)).to eq('spec/classes/config/server/connector_spec.rb')
      end
    end

    describe 'defines' do
      it 'should generate a acceptance test path correctly' do
        type = double('type')
        allow(type).to receive(:type).and_return(:definition)
        allow(type).to receive(:name).and_return('tomcat::config::server::connector')
        tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
        expect(tomcat.generate_file_path(type, true)).to eq('spec/acceptance/defines/config/server/connector_spec.rb')
      end

      it 'should generate a normal test path correctly' do
        type = double('type')
        allow(type).to receive(:type).and_return(:definition)
        allow(type).to receive(:name).and_return('tomcat::config::server::connector')
        tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
        expect(tomcat.generate_file_path(type, false)).to eq('spec/defines/config/server/connector_spec.rb')
      end
    end

    describe 'nodes' do
      it 'should generate a normal test path correctly' do
        type = double('type')
        allow(type).to receive(:type).and_return(:node)
        allow(type).to receive(:name).and_return('server1.example.com')
        tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
        expect(tomcat.generate_file_path(type, true)).to eq('spec/acceptance/hosts/server1.example.com_spec.rb')
      end
    end
  end

  it 'should generate a test file name correctly' do
    tomcat = Retrospec::Plugins::V1::Puppet.new(@opts[:module_path], @opts)
    expect(tomcat.generate_file_name('tomcat::config::server::connector')).to eq('connector_spec.rb')
    expect(tomcat.generate_file_name('tomcat')).to eq('tomcat_spec.rb')
    expect(tomcat.generate_file_name('tomcat::config')).to eq('config_spec.rb')
  end
end
