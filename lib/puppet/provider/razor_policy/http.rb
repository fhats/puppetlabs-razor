require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'razor', 'httpclient_providerbase'))
Puppet::Type.type(:razor_policy).provide(:http, :parent => Puppet_X::Razor::HttpClient_ProviderBase) do

  razor_type :policy

  def self.type_plural
    "policies"
  end

  def format_create_params
    params = default_create_params
    params[:hostname] = params.delete(:hostname_pattern)
    params[:enabled] = params[:enabled] == :true
    params
  end

  def broker
    { "name" => collection_get()["broker"]["name"] }
  end

  def enabled
    collection_get()['enabled']
  end

  def enabled=(value)
    if value == :true
      self.class.http_post("/api/commands/enable-policy", {:name => resource[:name]})
    else
      self.class.http_post("/api/commands/disable-policy", {:name => resource[:name]})
    end
  end

  def hostname_pattern
    collection_get()['configuration']['hostname_pattern']
  end

  def root_password
    collection_get()['configuration']['root_password']
  end

  def installer
    collection_get()['installer']['name']
  end

  def repo
    collection_get()['repo']['name']
  end
  [:enabled, :repo, :installer, :broker, :hostname_pattern, :root_password, :max_count, :rule_number, :tags].each { |p| setup_property p }

end

