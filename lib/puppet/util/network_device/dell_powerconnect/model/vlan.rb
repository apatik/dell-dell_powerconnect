require 'puppet/util/network_device/dell_powerconnect/model'
require 'puppet/util/network_device/dell_powerconnect/model/base'
require 'puppet/util/network_device/dell_powerconnect/model/scoped_value'

class Puppet::Util::NetworkDevice::Dell_powerconnect::Model::Vlan < Puppet::Util::NetworkDevice::Dell_powerconnect::Model::Base

  attr_reader :params, :name

  def initialize(transport, facts, options)
    super(transport, facts)
    # Initialize some defaults
    @params         ||= {}
    @name           = options[:name] if options.key? :name

    # Register all needed Modules based on the availiable Facts
    register_modules
  end

  def update(is = {}, should = {})
    return unless configuration_changed?(is, should, :keep_ensure => true)
    missing_commands = [is.keys, should.keys].flatten.uniq.sort - @params.keys.flatten.uniq.sort
    missing_commands.delete(:ensure)
    raise Puppet::Error, "Undefined commands for #{missing_commands.join(', ')}" unless missing_commands.empty?
    [is.keys, should.keys].flatten.uniq.sort.each do |property|
      next if property == :acl_type
      next if should[property] == :undef
      @params[property].value = :absent if should[property] == :absent || should[property].nil?
      @params[property].value = should[property] unless should[property] == :absent || should[property].nil?
    end
    before_update
    perform_update(is, should)
    after_update
  end

  def perform_update(is, should)
    case @params[:ensure].value
    when :present
      transport.command("vlan #{name}", :prompt => /\(config-vlan#{name}\)#\s?\z/n)
      Puppet::Util::NetworkDevice::Sorter.new(@params).tsort.each do |param|
        # We dont want to change undefined values
        next if should[param.name] == :undef || should[param.name].nil?
        # Skip the ensure property
        next if param.name == :ensure
        param.update(@transport, is[param.name]) unless is[param.name] == should[param.name]
      end
      transport.command("exit")
    when :absent
      transport.command("no vlan #{name}")
    end
  end

  def mod_path_base
    return 'puppet/util/network_device/dell_powerconnect/model/vlan'
  end

  def mod_const_base
    return Puppet::Util::NetworkDevice::Dell_powerconnect::Model::Vlan
  end

  def param_class
    return Puppet::Util::NetworkDevice::Dell_powerconnect::Model::ScopedValue
  end

  def register_modules
    register_new_module(:base)
  end
end
