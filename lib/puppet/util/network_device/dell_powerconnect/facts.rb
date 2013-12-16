require 'puppet/util/network_device/dell_powerconnect'
require 'puppet/util/network_device/dell_powerconnect/fact'
require 'puppet/util/network_device/dell_powerconnect/possible_facts'
require 'puppet/util/network_device/sorter'
require 'puppet/util/network_device/dsl'

class Puppet::Util::NetworkDevice::Dell_powerconnect::Facts

  include Puppet::Util::NetworkDevice::Dsl

  attr_reader :transport

  def initialize(transport)
    @transport = transport
  end

  def mod_path_base
    return 'puppet/util/network_device/dell_powerconnect/possible_facts'
  end

  def mod_const_base
    return Puppet::Util::NetworkDevice::Dell_powerconnect::PossibleFacts
  end

  def param_class
    return Puppet::Util::NetworkDevice::Dell_powerconnect::Fact
  end

  # TODO
  def facts
    @params
  end

  def facts_to_hash
    params_to_hash
  end
end
