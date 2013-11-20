require File.expand_path(File.join(File.dirname(__FILE__), '..', 'http'))
Puppet::Type.type(:razor_installer).provide(:http, :parent => Puppet::Provider::RazorHttpClient) do

  @@properties = ["os", "os_version", "description", "boot_seq", "templates"]
  @@type = "installer"

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
    # We have to force a no-op here since razor doesn't return the installer
    # text when asked for the details of an installer, making it hard for Puppet
    # to ensure equality.
    resource[:templates]
  end

end
