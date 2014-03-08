require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'razor', 'httpclient_providerbase'))
Puppet::Type.type(:razor_task).provide(:http, :parent => Puppet_X::Razor::HttpClient_ProviderBase) do
  razor_type :task

  def os
    collection_get()['os']['name']
  end

  def os_version
    collection_get()['os']['version']
  end

  def templates
    # TODO(fhats)
    # We have to force a no-op here since razor doesn't return the task
    # text when asked for the details of an task, making it hard for Puppet
    # to ensure equality.
    resource[:templates]
  end

  [:os, :os_version, :description, :boot_seq, :templates].each { |p| setup_property p }
end

