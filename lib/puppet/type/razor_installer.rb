Puppet::Type.newtype(:razor_installer) do
  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the installer; used internally by Razor to identify the installer"
  end

  newproperty(:base) do
    desc "An installer which this one is derived from, if any"
    defaultto "nothing"
  end

  newproperty(:os) do
    desc "The name of the OS"
    validate do |value|
      fail("os must be a string") unless value.is_a?(String)
    end
  end

  newproperty(:os_version) do
    desc "The version of the OS"
    validate do |value|
      fail("os_version must be a string") unless value.is_a?(String)
    end
  end

  newproperty(:description) do
    desc "A human-readable description of this installer"
    validate do |value|
      fail("description must be a string") unless value.is_a?(String)
    end
  end

  newproperty(:boot_seq) do
    desc "A hash mapping the boot counter or 'default' to a template"
    validate do |value|
      fail("boot_seq must be a hash") unless value.is_a?(Hash)
      fail("Keys in boot_seq must be strings") unless value.keys.all? { |x| x.is_a?(String) }
    end
  end

  newproperty(:templates) do
    desc "A hash mapping template names to the actual ERB template text"
    validate do |value|
      fail("templates must be a hash") unless value.is_a?(Hash)
      fail("Keys in templates must be strings") unless value.keys.all? { |x| x.is_a?(String) }
    end
  end

end
