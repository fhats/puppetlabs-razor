Puppet::Type.newtype(:razor_policy) do
  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the policy; used internally by Razor to identify the policy"
  end

  newproperty(:repo) do
    desc "The name of the repo this policy should use."
    munge do |value|
      if value.is_a?(String)
        { "name" => value }
      else
        value
      end
    end
  end

  newproperty(:installer) do
    desc "The name of the installer this policy should use."

    munge do |value|
      if value.is_a?(String)
        { "name" => value }
      else
        value
      end
    end
  end

  newproperty(:broker) do
    desc "The name of the broker this policy should use."

    munge do |value|
      if value.is_a?(String)
        { "name" => value }
      else
        value
      end
    end
  end

  newproperty(:hostname_pattern) do
    desc "A pattern for the host names of the nodes bound to the policy"
  end

  newproperty(:root_password) do
    desc "The root password for machines imaged using this policy"
  end

  newproperty(:max_count) do
    desc "The maximum number of machines that should be imaged using this policy"
    munge do |value|
      value.to_i
    end
  end

  newproperty(:rule_number) do
    desc "The precedence this policy should take when overlapping with other policies."
    munge do |value|
      value.to_i
    end
  end

  newproperty(:tags, :array_matching => :all) do
    desc "An array of the tags that should be used for matching this policy."
    validate do |value|
      fail("tags must be an array") unless value.is_a?(Array)
      fail("each entry in tags must be a hash") unless value.all? { |x| x.is_a?(Hash) }
    end
  end

end
