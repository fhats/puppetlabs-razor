require File.expand_path(File.join(File.dirname(__FILE__), '..', 'http'))
Puppet::Type.type(:razor_repo).provide(:http, :parent => Puppet::Provider::RazorHttpClient) do

  def exists?
    self.class.collection_has?("repos", resource[:name])
  end

  def self.instances
    repos = self.collection_list("repos")
    repos.collect do |repo|
      repo_name = repo["name"]
      repo_details = self.collection_get("repos", repo_name)
      url = repo_details["iso_url"] || repo_details["url"]
      iso = url == repo_details["iso_url"]
      new( :name => repo_name,
           :url  => url,
           :iso  => iso
      )
    end
  end

  def create
    path = "/api/commands/create-repo"
    data = {
      :name     => resource[:name],
      "iso-url" => (resource[:url] if resource[:iso]),
      :url      => (resource[:url] unless resource[:iso])
    }.reject{ |k,v| v.nil? }
    status_code, body = self.class.http_post(path, data)
    fail("Error creating #{resource[:name]}: #{status_code} #{body}") unless status_code == 202
  end

  def destroy
    path = "/api/commands/delete-repo"
    data = {
      :name    => resource[:name],
    }
    status_code, body = self.class.http_post(path, data)
    fail("Error destroying #{resource[:name]}: #{status_code} #{body}") unless status_code == 202
  end

  def url
    body = self.class.collection_get("repos", resource[:name])
    resource[:iso] ? body["iso_url"] : body["url"]
  end

  def url=(value)
    self.destroy()
    self.create()
  end

end
