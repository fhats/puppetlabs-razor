require File.expand_path(File.join(File.dirname(__FILE__), '..', 'http'))
Puppet::Type.type(:razor_broker).provide(:http, :parent => Puppet::Provider::RazorHttpClient) do

  def self.properties
    ["configuration", "type"]
  end

  def self.razor_type
    "broker"
  end

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
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    inst["broker-type"]
  end

end
