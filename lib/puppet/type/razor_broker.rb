Puppet::Type.newtype(:razor_broker) do
  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the broker; used internally by Razor to identify the broker"
  end

  newproperty(:type) do
    desc "The broker type for this broker (must be in Razor's broker path)"
  end

  newproperty(:configuration) do
    desc "A configuration hash which can be understood by the specified broker"
    validate do |value|
      unless value.is_a?(Hash)
        fail("Configuration must be a hash")
      end
    end
  end

end
