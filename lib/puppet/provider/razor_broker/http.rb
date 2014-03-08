require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'razor', 'httpclient_providerbase'))
Puppet::Type.type(:razor_broker).provide(:http, :parent => Puppet_X::Razor::HttpClient_ProviderBase) do

  razor_type :broker

  def self.format_hash_params(instance_details)
    name = instance_details["name"]
    configuration = instance_details["configuration"]
    broker_type = instance_details["broker-type"]
    {
      :name          => name,
      :configuration => configuration,
      :type          => broker_type
    }
  end

  def format_create_params
    {
      :name          => resource[:name],
      :configuration => resource[:configuration],
      :"broker-type" => resource[:type]
    }
  end

  def type
    collection_get()['broker-type']
  end

  setup_property :configuration
  setup_property :type
end

