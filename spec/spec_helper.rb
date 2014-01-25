require 'rspec-puppet'
require 'spec_helper'
require 'yaml'
require 'puppet/util/network_device/dell_powerconnect/device'
require 'puppet/util/network_device/base_powerconnect'
require 'rspec/mocks'
require 'puppet/provider/dell_powerconnect'
require 'puppet/provider/powerconnect_responses'
require 'puppet/provider/powerconnect_messages'
require 'spec_lib/puppet_spec/deviceconf'
require 'spec_lib/puppet_spec/integrationfixture'

module_path = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..','lib'))

RSpec.configure do |c|
  c.module_path = module_path
  c.manifest_dir = File.join(module_path, 'manifests')

  if Puppet::Util::Platform.windows?
    c.output_stream = $stdout
    c.error_stream = $stderr

    c.formatters.each do |f|
      if not f.instance_variable_get(:@output).kind_of?(::File)
        f.instance_variable_set(:@output, $stdout)
      end
    end
  end
end