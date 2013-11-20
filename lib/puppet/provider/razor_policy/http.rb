require File.expand_path(File.join(File.dirname(__FILE__), '..', 'http'))
Puppet::Type.type(:razor_policy).provide(:http, :parent => Puppet::Provider::RazorHttpClient) do

  @@properties = ["repo", "installer", "broker", "hostname_pattern", "root_password", "max_count", "rule_number", "tags"]
  @@type = "policy"

  def self.type_plural
    "policies"
  end

  def format_create_params
    params = default_create_params
    params[:hostname] = params.delete(:hostname_pattern)
    params
  end

  def broker
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    { "name" => inst["broker"]["name"] }
  end

  def hostname_pattern
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    inst["configuration"]["hostname_pattern"]
  end

  def root_password
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    inst["configuration"]["root_password"]
  end

  def installer
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    { "name" => inst["installer"]["name"] }
  end

  def repo
    inst = self.class.collection_get("#{self.class.type_plural}", resource[:name])
    { "name" => inst["repo"]["name"] }
  end
end
