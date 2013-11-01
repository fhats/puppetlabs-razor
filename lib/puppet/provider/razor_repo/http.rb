require "rubygems"
require "json"
require "net/http"

Puppet::Type.type(:razor_repo).provide(:http) do

  def exists?
    path = "/api/collections/repos/#{resource[:name]}"
    http = Net::HTTP.new("localhost", 8080)
    response = http.request_get(path)
    response.code == 200
  end

  def create
    path = "/api/commands/create-repo"
    http = Net::HTTP.new("localhost", 8080)
    data = {
      :name    => resource[:name],
      :iso_url => (resource[:url] if resource[:iso]),
      :url     => (resource[:url] unless resource[:iso])
    }.reject{ |k,v| v.nil? }
    response = http.request_post(path, data.to_json)

    fail("Could not contact the razor server") unless response.code == 202
  end

  def destroy
    path = "/api/commands/delete-repo"
    http = Net::HTTP.new("localhost", 8080)
    data = {
      :name    => resource[:name],
    }
    response = http.request_post(path, data.to_json)
    fail("Could not contact the razor server") unless response.code == 202
  end

  def url
    path = "/api/collections/repos/#{resource[:name]}"
    http = Net::HTTP.new("localhost", 8080)
    response = http.request_get(path)

    fail("Could not contact the razor server") unless response.code == 200

    response_body = JSON.parse(response.body)
    resource[:iso] ? response_body["iso_url"] : response_body["url"]
  end

  def url=(value)
    self.destroy()
    self.create()
  end

end
