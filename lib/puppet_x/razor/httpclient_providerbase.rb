require "rubygems"
require "json"
require "net/http"

class Puppet_X::Razor::HttpClient_ProviderBase < Puppet::Provider
  @@client = Net::HTTP.new("localhost", 8080)

  def self.setup_property(property)
    if !self.respond_to? property
      define_method property do
        inst = collection_get()[property]
      end
    end
    if !self.respond_to? "#{property}="
      define_method "#{property}=" do
        @property_hash[:needs_flush] = true
      end
    end
  end

  def flush
    if @property_hash[:needs_flush]
      self.destroy()
      self.create()
    end
  end

  def self.type_plural
    "#{@@razor_type}s"
  end

  def exists?
    self.class.collection_has?("#{self.class.type_plural}", resource[:name])
  end

  def self.instances
    insts = self.collection_list("#{self.class.type_plural}")
    insts.collect do |instance|
      instance_details = collection_get(instance)
      new(self.format_hash_params(instance_details))
    end
  end

  def self.format_hash_params(instance_details)
    instance_details
  end

  def self.razor_type(type)
    @@razor_type = type
  end

  def create
    path = "/api/commands/create-#{@@razor_type}"
    data = self.format_create_params
    status_code, body = self.class.http_post(path, data)
    fail("Error creating #{self.class.razor_type} #{resource[:name]}: #{status_code} #{body}") unless status_code == 202
  end

  def format_create_params
    default_create_params
  end

  def default_create_params
    params = {
      :name => resource[:name]
    }
    self.class.properties().each { |prop|
      index = prop.to_sym
      params[index] = resource[index]
    }
    params
  end

  def destroy
    path = "/api/commands/delete-#{self.class.razor_type}"
    data = {
      :name    => resource[:name],
    }
    status_code, body = self.class.http_post(path, data)
    fail("Error destroying #{self.class.razor_type} #{resource[:name]}: #{status_code} #{body}") unless status_code == 202
  end

  def self.http_get(path, as_json=true)
    response = @@client.request_get(path)
    return response.code.to_i, (as_json ? JSON.load(response.body) : response.body)
  end

  def self.http_post(path, data, as_json=true)
    headers = {
      "Content-Type" => "application/json"
    }
    response = @@client.request_post(path, data.to_json, headers)
    return response.code.to_i, (as_json ? JSON.load(response.body) : response.body)
  end

  def self.collection_has?(collection_type, identifier)
    path = "/api/collections/#{collection_type}/#{identifier}"
    status_code, body = self.http_get(path, as_json=false)
    if status_code == 200
      true
    elsif status_code == 404
      false
    else
      self.post_failure(status_code, body)
    end
  end

  def self.collection_list(collection_type)
    path = "/api/collections/#{collection_type}"
    status_code, body = self.http_get(path)

    self.post_failure(status_code, body) unless status_code == 200
    body
  end

  def collection_get(identifier = resource[:name])
    status_code, body = self.http_get("/api/collections/#{self.class.type_plural}/#{identifier}")

    self.post_failure(status_code, body, identifier) unless 200 == status_code
    body
  end

  def self.post_failure(status_code, body, ident=nil)
    activity = ident ? "retrieving #{self.class.razor_type} #{ident}" : "contacting razor server"
    fail("Unexpected response #{activity}: #{status_code} #{body}")
  end

end

