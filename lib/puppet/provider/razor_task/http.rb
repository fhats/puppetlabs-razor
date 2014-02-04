require File.expand_path(File.join(File.dirname(__FILE__), '..', 'http'))
Puppet::Type.type(:razor_task).provide(:http, :parent => Puppet::Provider::RazorHttpClient) do

  def self.properties
    ["os", "os_version", "description", "boot_seq", "templates"]
  end

  def self.razor_type
    "task"
  end

  def os
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    inst["os"]["name"]
  end

  def os_version
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    inst["os"]["version"]
  end

  def templates
    # TODO(fhats)
    # We have to force a no-op here since razor doesn't return the task
    # text when asked for the details of an task, making it hard for Puppet
    # to ensure equality.
    resource[:templates]
  end

end
