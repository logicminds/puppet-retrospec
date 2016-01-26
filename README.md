Puppet-Retrospec
================
A retrospec plugin for puppet that generates puppet rspec test code based on the current code inside your module.

Proper testing is hard especially when you are new to ruby, rspec or even puppet.

Retrospec makes it dead simple to get started with advanced puppet module development.  Retrospec will scan you puppet module files and actually write some very basic rspec-puppet test code.  Thus this gem will retrofit your existing puppet module with everything needed to get going with puppet unit testing.  Additionally, retrospec will outfit your module with any file you can think of.  Say goodbye to repetitive module setup.

Not only will retrospec generate tests for you, it will also assist in creating many of the advanced puppet module files like custom facts, functions, types, providers and schemas, as well as their associated test files. It will even create the module from scratch if so desired.

The project was named retrospec because there are many times when you need to retrofit your module with various things.

If you like this project, star it and tell people!

Table of Contents
=================

  * [Build Status](#build-status)
  * [News](#news)
  * [Install](#install)
  * [How to use](#usage)
    * [Module Path](#module-path)
    * [Command Line Help](#command-line-help)
  * [Design Goals](#design-goals)
  * [Using the Generators](#using-the-generators)
    * [Auto spec file creation](#auto-spec-file-creation)
    * [Creating a new puppet module](#creating-a-new-puppet-module)
    * [Creating a new fact](#creating-a-new-fact)
    * [Creating a new provider](#creating-a-new-provider)
    * [Creating a new function](#creating-a-new-function)
    * [Creating a new type](#creating-a-new-type)
    * [Creating a schema file](#creating-a-new-module-schema-file)
  * [Dependency](#dependency)
  * [Enable Future Parser](#enabling-the-future-parser)
  * [Configuration](#configuration)
  * [Example](#example)
  * [About the test suite](#about-the-test-suite)
  * [How Does it do this](#how-does-it-do-this)
  * [Beaker Testing](#beaker-testing)
  * [Troubleshooting](#troubleshooting)
  * [Running Tests](#running-tests)
  * [Understanding Variable Resolution](#understanding-variable-resolution)
  * [Todo](#todo)
  * [Future Parser Support](#future-parser-support)
  * [Paid Support](#paid-support)

TOC Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## Build Status
[![Build Status](https://travis-ci.org/logicminds/puppet-retrospec.png)](https://travis-ci.org/logicminds/puppet-retrospec)
[![Gem Version](https://badge.fury.io/rb/puppet-retrospec.svg)](http://badge.fury.io/rb/puppet-retrospec)

## News
### 1-18-16
A slew of new features has been added with the 0.12 update. If you already use retrospec to retrofit your modules, now you can use retrospec to generate some of the more advanced puppet module customizations such as:

- custom facts
- providers
- custom types
- functions (v3 and v4)
- parameter schemas  

This has been a feature in the making since Puppetconf 2015.  I would have finished this sooner but was sucked in
binge watching a bunch of Netflix shows.   Check out `retrospec puppet -h` for a list of all new subcommands.


## Install
`gem install puppet-retrospec`  

This will also install the retrospec framework that is required to use the plugin.

## Usage
The easiest way to get started using retrospec-puppet is to run `retrospec puppet`
from within your module directory. Retrospec uses the current directory if no options
are specified.  Expect to run `retrospec puppet` multiple times throughout the day.
Retrospec will never overwrite a file, so if something already exists retrospec will
skip the file. Many times you will find yourself deleting existing files and allowing retrospec to recreate them based on updated templates.

### Module Path
By default the module path is dynamically set based on the current directory.
If you need to point to a directory outside the current directory you can use the `--module_path` option.  This option is built into the retrospec framework
so be sure to use `retrospec -m path_to_module`.

### Command Line Help
There is a `-h` at every level of commands and subcommands.

 - `retrospec -h`
 - `retrospec puppet -h`
 - `retrospec puppet <sub_command> -h`

```
[puppet@puppetdev ~]$ retrospec -m /tmp/test3323 puppet -h
Generates puppet rspec test code based on the classes and defines inside the manifests directory.

Subcommands:
new_module
new_fact
new_type
new_provider
new_function

  -t, --template-dir=<s>        Path to templates directory (only for overriding Retrospec templates)
                                (default: /Users/cosman/.retrospec/repos/retrospec-puppet-templates)
  -s, --scm-url=<s>             SCM url for retrospec templates (default:
                                https://github.com/nwops/retrospec-templates)
  -n, --name=<s>                The name of the module you wish to create (default: test3323)
  -b, --branch=<s>              Branch you want to use for the retrospec template repo (default: master)
  -a, --namespace=<s>           The namespace to use only when creating a new module (default: namespace)
  -e, --enable-beaker-tests     Enable the creation of beaker tests
  -l, --enable-future-parser    Enables the future parser only during validation
  -v, --version                 Print version and exit
  -h, --help                    Show this message  -h, --help                    Show this message
```

## Design Goals
One of the design goals of this plugin is to try to introspect as much information as possible so we don't need input from the user. If you are not sure what default values are used, use the `-h` option and the defaults will be revealed. Most of the defaults are dynamic.  

Another design goal is to allow the user to configure every option, so that passing
additional options is not required when configured correctly.  Please see the [Configuration Section](#configuration) for setting a config file.

## Using the Generators
At this time the generators are limited to just creating facts, providers, types, functions and schemas. As time goes on I envision more complicated puppet customizations like faces, indirectors, reports, or whatever else the community deems important.

*Note:* the unit tests files created are only meant to get you started. Be aware that these unit test templates are not perfect and will need further refinement. Testing in this area is not well documented so its based of my own experience and imperfect.  Please submit a PR if you find ways to improve these [templates](https://github.com/nwops/retrospec-templates).  

### Auto spec file creation
Each generator will also create associated test files by default without having to use the generator command.  So if there is a existing module without tests for one of these things, retrospec will create the test files automatically. There is no need to run the generator subcommands to generate spec files for existing puppet module ruby files.  

### Creating a new puppet module
You can create a puppet module from scratch using retrospec.
This can be compared to using `puppet module generate` with a skeleton. Retrospec
differs slightly in that you can specify which skeleton/templates to use at creation time.  This is helpful when working with different clients or puppet versions.
Unlike `puppet module generate` retrospec does not force you to create a
directory with a namespace.  This means you do not need to rename anything after creating it. By default retrospec will consult the retrospec config file for default settings which can be overridden on the command line.  Having the config in place can save you a few key strokes.

```
# use -m to specify the module path
retrospec -m /tmp/test_module_123 puppet new_module -n lmc-test123
# or without specifying module_path
cd /tmp/modules
export RETROSPEC_PUPPET_AUTO_GENERATE=true
retrospec puppet new_module -n lmc-test124
 + /private/tmp/modules/lmc-test124/manifests/
 + /private/tmp/modules/lmc-test124/manifests/init.pp  
 + /private/tmp/modules/lmc-test124/metadata.json
```

### Creating a new fact
Creating a new fact is easy with retrospec. Just use the following to
create a fact and unit test.
```
retrospec -m /tmp/test_module_123 puppet new_fact -n datacenter
Successfully ran hook: /Users/cosman/github/retrospec-templates/clone-hook
 + /private/tmp/modules/test123/lib/facter/
 + /private/tmp/modules/test123/lib/facter/datacenter.rb
 + /private/tmp/modules/test123/spec/unit/facter/
 + /private/tmp/modules/test123/spec/unit/facter/datacenter_spec.rb
```

### Creating a new provider
Create a new provider is easy.  Just specify the puppet type you want the generator
to use and the stub code for a provider and provider test file will be created.

```
cd testabc124
retrospec puppet new_provider -t package -n ibm_pkg
Successfully ran hook: /Users/user1/retrospec-templates/clone-hook

 + /tmp/testabc124/lib/puppet/provider/package/
 + /tmp/testabc124/lib/puppet/provider/package/ibm_pkg.rb
Successfully ran hook: /Users/user1/retrospec-templates/pre-hook
```
### Creating a new function
Creating a new function is just as easy as other generators. Use the new_function
sub command and specify the name.  Specify `--type v4` if you wish to create
a new 'v4' function, otherwise v3 is the default. Since testing functions
can be done in both rspec-ruby and rspec-puppet you can specify the test type as
well and retrospec will default to `rspec-puppet`.

```
cd testabc124
retrospec puppet new_function -n is_url
Successfully ran hook: /Users/user1/retrospec-templates/clone-hook
+ /private/tmp/testabc124/lib/puppet/parser/functions/
+ /private/tmp/testabc124/lib/puppet/parser/functions/is_url.rb
```

### Creating a new type
Creating a type is similar to any other generator. You can specify which parameters,
properties, and providers to generate. Retrospec will generate a default provider
if none are specified.

```
retrospec puppet new_type -n test_type --parameters param1 param2 --properties prop1 prop2 --providers default
Successfully ran hook: /Users/user1/retrospec-templates/clone-hook

 + /private/tmp/testabc124/lib/puppet/type/
 + /private/tmp/testabc124/lib/puppet/type/test_type.rb
 + /private/tmp/testabc124/lib/puppet/provider/test_type/
 + /private/tmp/testabc124/lib/puppet/provider/test_type/default.rb
Successfully ran hook: /Users/user1/retrospec-templates/pre-hook
```
### Creating a new module schema file
Schema files are something I came up with recently and something I have found useful for various things. These schema files map all the puppet parameters in the classes and defines you have inside your module. You can use these schema files for validating hiera, generating documentation, or to serve as parameter documentation.  At this time the generator map only known datatypes so its up to you to define some of the complex data structures you have for puppet parameters.
Maintaining a schema file is optional, but is incredible useful for people using your module and validating hiera data. Schema files are generated by default with every `retrospec puppet` run.

```
cd testabc124
retrospec puppet
+ /private/tmp/testabc124/testabc124_schema.yaml
```

## Dependency
Retrospec relies heavily on the puppet 3.7.x codebase.  Because of this hard dependency the puppet gem is vendored into the library so there should not be conflicts with your existing puppet gem.  

## Enabling the future parser

`retrospec -m ~/projects/puppet_modules/apache puppet --enable-future-parser`

Please see #future-parser-support for why this might be required.

## Configuration
 Below is a list of options that you can set in the config file.  Setting these options will help cut down on passing parameters. (/Users/username/.retrospec/config.yaml)  `retrospec -h`

 *Note:* if might be useful to have several config files for different clients or
 situations where you want to easily swap out templates or options.
 `retrospec --config-map /Users/user1/.retrospec/client1.yaml`

```yaml
# used by the main puppet plugin and every subcommand
plugins::puppet::templates::url: https://github.com/nwops/retrospec-templates
plugins::puppet::templates::ref: master
plugins::puppet::enable_beaker_tests: true
plugins::puppet::enable_future_parser: true
plugins::puppet::template_dir: /Users/username/.retrospec/repos/retrospec-puppet-templates
# used when creating new modules
plugins::puppet::namespace: organization
plugins::puppet::default_license: 'Apache-2.0'
plugins::puppet::author: your_name
# used when creating new functions
plugins::puppet::default_function_version: v3
plugins::puppet::default_function_test_type: rspec


```

*Note:* your not required to set any of these as they can be specified on the cli and also default to reasonable values.

## Example
Below you can see that it creates files for every resource in the apache module in addition to other files that you need for unit testing puppet code. Rspec-puppet best practices says to put definitions in a defines folder and classes in a classes folder since it infers what kind of resource it is based on this convention.  Retrospec sets up this scaffolding for you.  Don't like the files that came with your module?  Simply delete the files and regenerate them with `puppet retrospec`.

```shell
$ pwd
/Users/cosman/github/puppetlabs-apache
$ retrospec puppet
 + /Users/cosman/github/puppetlabs-apache/Gemfile
  + /Users/cosman/github/puppetlabs-apache/Rakefile
  + /Users/cosman/github/puppetlabs-apache/spec/
  + /Users/cosman/github/puppetlabs-apache/spec/shared_contexts.rb
  + /Users/cosman/github/puppetlabs-apache/spec/spec_helper.rb
  + /Users/cosman/github/puppetlabs-apache/.fixtures.yml
  + /Users/cosman/github/puppetlabs-apache/.gitignore
  + /Users/cosman/github/puppetlabs-apache/.travis.yml
  + /Users/cosman/github/puppetlabs-apache/spec/classes/
  + /Users/cosman/github/puppetlabs-apache/spec/classes/default_mods_spec.rb
  + /Users/cosman/github/puppetlabs-apache/spec/classes/dev_spec.rb
  + /Users/cosman/github/puppetlabs-apache/spec/classes/mod/disk_cache_spec.rb
  + /Users/cosman/github/puppetlabs-apache/spec/classes/service_spec.rb
  + /Users/cosman/github/puppetlabs-apache/spec/classes/ssl_spec.rb
  + /Users/cosman/github/puppetlabs-apache/spec/defines/
  + /Users/cosman/github/puppetlabs-apache/spec/defines/balancer_spec.rb
  + /Users/cosman/github/puppetlabs-apache/spec/defines/balancermember_spec.rb
  + /Users/cosman/github/puppetlabs-apache/spec/defines/vhost_spec.rb

```

Looking at the file we can see that it did a lot of work for us.  Retrospec generated many tests automatically. However the variable resolution isn't perfect so you will need to manually resolve some variables.  This doesn't produce 100% coverage but all you did was press enter to produce all this anyways. Below is the classes/apache_spec.rb file.  Notice that while Retrospec created all these files, you still need to do more work.
Retrospec is only here to setup your module for testing, which might save you several hours each time you create a module. Below I'll go through the different parts of automation that you can use in your testing.


```ruby
require 'spec_helper'
require 'shared_contexts'

describe 'apache' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera


  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:default_mods => true,
      #:default_vhost => true,
      #:default_ssl_vhost => false,
      #:default_ssl_cert => $apache::params::default_ssl_cert,
      #:default_ssl_key => $apache::params::default_ssl_key,
      #:default_ssl_chain => undef,
      #:default_ssl_ca => undef,
      #:default_ssl_crl_path => undef,
      #:default_ssl_crl => undef,
      #:service_enable => true,
      #:purge_configs => true,
      #:purge_vdir => false,
      #:serveradmin => "root@localhost",
      #:sendfile => false,
      #:error_documents => false,
      #:httpd_dir => $apache::params::httpd_dir,
      #:confd_dir => $apache::params::confd_dir,
      #:vhost_dir => $apache::params::vhost_dir,
      #:vhost_enable_dir => $apache::params::vhost_enable_dir,
      #:mod_dir => $apache::params::mod_dir,
      #:mod_enable_dir => $apache::params::mod_enable_dir,
      #:mpm_module => $apache::params::mpm_module,
      #:conf_template => $apache::params::conf_template,
      #:servername => $apache::params::servername,
      #:user => $apache::params::user,
      #:group => $apache::params::group,
      #:keepalive => $apache::params::keepalive,
      #:keepalive_timeout => $apache::params::keepalive_timeout,
      #:logroot => $apache::params::logroot,
      #:ports_file => $apache::params::ports_file,
      #:server_tokens => "OS",
      #:server_signature => "On",
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_package('httpd').
             with({"ensure"=>"installed",
                   "name"=>"$apache::params::apache_name",
                   "notify"=>"Class[Apache::Service]"})
  end
  it do
    is_expected.to contain_group('$apache::params::group').
             with({"ensure"=>"present",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_user('$apache::params::user').
             with({"ensure"=>"present",
                   "gid"=>"$apache::params::group",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_class('apache::service').
             with({"service_enable"=>"true"})
  end
  it do
    is_expected.to contain_exec('mkdir $apache::params::confd_dir').
             with({"creates"=>"$apache::params::confd_dir",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_file('$apache::params::confd_dir').
             with({"ensure"=>"directory",
                   "recurse"=>"true",
                   "purge"=>"$purge_confd",
                   "notify"=>"Class[Apache::Service]",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_concat('$apache::params::ports_file').
             with({"owner"=>"root",
                   "group"=>"root",
                   "mode"=>"0644",
                   "notify"=>"Class[Apache::Service]",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_concat__fragment('Apache ports header').
             with({"target"=>"$apache::params::ports_file",
                   "content"=>"template(apache/ports_header.erb)"})
  end
  it do
    is_expected.to contain_exec('mkdir $apache::params::mod_dir').
             with({"creates"=>"$apache::params::mod_dir",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_file('$apache::params::mod_dir').
             with({"ensure"=>"directory",
                   "recurse"=>"true",
                   "purge"=>"true",
                   "notify"=>"Class[Apache::Service]",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_exec('mkdir $apache::params::mod_enable_dir').
             with({"creates"=>"$apache::params::mod_enable_dir",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_file('$apache::params::mod_enable_dir').
             with({"ensure"=>"directory",
                   "recurse"=>"true",
                   "purge"=>"true",
                   "notify"=>"Class[Apache::Service]",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_exec('mkdir $apache::params::vhost_dir').
             with({"creates"=>"$apache::params::vhost_dir",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_file('$apache::params::vhost_dir').
             with({"ensure"=>"directory",
                   "recurse"=>"true",
                   "purge"=>"true",
                   "notify"=>"Class[Apache::Service]",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_exec('mkdir $vhost_load_dir').
             with({"creates"=>"$vhost_load_dir",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_file('$apache::params::vhost_enable_dir').
             with({"ensure"=>"directory",
                   "recurse"=>"true",
                   "purge"=>"true",
                   "notify"=>"Class[Apache::Service]",
                   "require"=>"Package[httpd]"})
  end
  it do
    is_expected.to contain_file('$apache::params::conf_dir/$apache::params::conf_file').
             with({"ensure"=>"file",
                   "content"=>"template($conf_template)",
                   "notify"=>"Class[Apache::Service]",
                   "require"=>"Package[httpd]"})
  end
end

```

## About the test suite
At this time the test suite that is automatically generated is very basic.  Essentially it just creates a test for every resource not in a code block with the exception of conditional code blocks.  While this might be all you need, the more complex your code is the less retrospec will generate until further improvements to the generator are made.

However, one of the major stumbling blocks is just constructing everything in the spec
directory which retrospec does for you automatically.  Its now up to you to further enhance your test suite with more tests and conditional logic using describe blocks and such.  You will notice that some variables are not resolved. Currently this is a limitation that I hope to overcome, but until now its up to you to manually resolve those variables prefixed with a '$'.

Example:

```ruby
should contain_file('$::tomcat::params::catalina_home').
             with({"ensure"=>"directory",
                   "owner"=>"$::tomcat::params::user",
                   "group"=>"$::tomcat::params::group"})

```

For now you will probably want to read up on the following documentation:

* [Puppet Rspec](http://rspec-puppet.com)
* [Puppet spec helper](https://github.com/puppetlabs/puppetlabs_spec_helper/blob/master/README.markdown)


## How Does it do this
Basically Retrospec uses the puppet lexer and parser to scan your code in order to fill out some basic templates that will retrofit your puppet module with unit tests.  Currently I rely on the old AST parser to generate all this.  This is why puppet 3.7 is vendored into the gem.

## Overriding the Templates
There may be a time when you want to override the default templates used to generate the rspec related files. By default retrospec will clone these [templates](https://github.com/nwops/retrospec-templates) and place inside the default or specified template directory.  

```shell
-t, --template-dir=<s>        Path to templates directory (only for overriding Retrospec templates) (default: /Users/cosman/github/retrospec-templates)
-s, --scm-url=<s>             SCM url for retrospec templates (default: git@github.com:nwops/retrospec-templates.git)
-b, --branch=<s>              Branch you want to use for the retrospec template repo (default: master)

```

### Environment variables to set template defaults
RETROSPEC_PUPPET_SCM_URL  # set this to auto set your scm url to the templates
RETROSPEC_PUPPET_SCM_BRANCH # set this to auto checkout a particular branch (only works upon initial checkout)

After running retrospec, retrospec will clone the templates from the default template url or from whatever you set to the templates path.  If you have already created the erb file in the templates location, then retrospec will not overwrite the file as there will be a SCM conflict. You can use multiple template paths if you use them for different projects so just be sure the set the correct template option when running retrospec.  `retrospec -t`

The default user location for the templates when not using `retrospec -t` variable is ~/.retrospec/repos/retrospec-puppet-templates

Example:
`--template-dir=~/my_templates`

## Beaker Testing
Beaker is Puppetlabs acceptance testing framework that you use to test puppet code on real machines.  Beaker is fairly new and is subject to frequent changes.  Testing patterns have not been established yet so consider beaker support in puppet-retrospec
to be experimental.

If you wish to enable the creation of beaker tests you can use the following cli option.  By default these acceptance tests are not created.  However at a later time they will be enabled by default.

`--enable-beaker-tests`

I am no expert in Beaker so if you see an issue with the templates, acceptance_spec_helper or other workflow, please issue a PR.

## Troubleshooting
If you see the following, this error means that you need to add a fixture to the fixtures file. At this time I have no idea what your module requires.  So just add the module that this class belongs to in the .fixtures file.

See [fixtures doc](https://github.com/puppetlabs/puppetlabs_spec_helper#using-fixtures) for more information

```shell
8) tomcat::instance::source
     Failure/Error: it { should compile }
     Puppet::Error:
       Could not find class staging for coreys-macbook-pro-2.local on node coreys-macbook-pro-2.local
     # ./spec/defines/instance/source_spec.rb:34:in `block (2 levels) in <top (required)>'
```

If you see something like the following, this means your current module is using a much older version of Rspec.  Retrospec uses Rspec 3 syntax so you need to update your rspec version.  If you have tests that using older rspec syntax, take a look
at [transpec](https://github.com/yujinakayama/transpec)

```shell
   103) apache::vhost
        Failure/Error: is_expected.to contain_file('').
        NameError:
          undefined local variable or method `is_expected' for #<RSpec::Core::ExampleGroup::Nested_59:0x007ff9eaab75e8>
        # ./spec/defines/vhost_spec.rb:103:in `block (2 levels) in <top (required)>'

```

If your tests will not run after running retrospec. Your spec_helper, Rakefile and Gemfile may not be compatible with the pre-defined templates.  Just delete these files and re-run retrospec to recreate them.  Add back any modifications you might have had.

## Running Retrospec Tests
Puppet-retrospec tests its code against real modules downloaded directly from puppet forge.

To run a clean test suite and re-download you must run with environment variable set
```
RETROSPEC_CLEAN_UP_TEST_MODULES=true bundle exec rake spec
```

Otherwise to save time we skip the removal of test puppet modules therefore we don't re-download
```
bundle exec rake spec
```

## Understanding Variable Resolution
Because the code does not rely on catalog compilation we have to build our own scope through non trival methods.  Some variables will get resolved while others will not.  As this project progresses we might find a better way at resolving variables.  For now, some variable will require manual interpolation.

### Variable Resolution workflow.

1. load code in parser and find all parameters. Store these parameter values.
2. Find all vardef objects, resolve them if possible and store the values
3. Anything contained in a block of code is currently ignored, until later refinement.

##Future Parser Support
Currently Retrospec uses the old/current AST parser for code parsing.  If your code contains future parser syntax the current parser will fail to render some resource definitions but will still render the spec file template without parameters
and resource tests that are contained in your manifest. Retrospec is still extremely useful with Puppet 4.

Since Puppet 4 introduces many new things and breaks many other things  I am not sure
which side of the grass is greener at this time.  What I do know is that most people are using Puppet 3 and it may take time to move to Puppet 4.  I would suspect Retrospec would be more valuable for those moving to Puppet 4 who don't have unit tests that currently have Puppet 3 codebases.  For those with a clean slate and start directly in Puppet 4, Retrospec will still be able to produce the templates but some of the test cases will be missing if the old AST parser cannot read future code syntax.  If your puppet 4 codebase is compatible with puppet 3 syntax there should not be an issue.

In order to allow future parser validation please run retrospec with the following option.

 ```shell
    retrospec puppet --enable-future-parser

 ```

##Ruby Support
Currently this library only supports ruby >= 1.9.3.  It might work on 1.8.7 but I won't support if it fails.

##Paid Support
Want to see new features developed much faster?  Contact me about a support contract so I can develop this tool during
the day instead of after work.  contact: corey@nwops.io
