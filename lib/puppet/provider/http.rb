require "rubygems"
require "json"
require "net/http"

class Puppet::Provider::RazorHttpClient < Puppet::Provider

  @@client = Net::HTTP.new("localhost", 8080)

  def self.http_get(path)
    response = @@client.request_get(path)
    return response.code.to_i, JSON.load(response.body)
  end

  def self.http_post(path, data)
    headers = {
      "Content-Type" => "application/json"
    }
    response = @@client.request_post(path, data.to_json, headers)
    return response.code.to_i, JSON.load(response.body)
  end

  def self.collection_has?(collection_type, identifier)
    path = "/api/collections/#{collection_type}/#{identifier}"
    status_code, body = self.http_get(path)
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

  def self.collection_get(collection_type, identifier)
    path = "/api/collections/#{collection_type}/#{identifier}"
    status_code, body = self.http_get(path)

    self.post_failure(status_code, body, identifier) unless status_code == 200
    body
  end

  def self.post_failure(status_code, body, ident=nil)
    activity = ident ? "retrieving #{ident}" : "contacting razor server"
    fail("Unexpected response #{activity}: #{status_code} #{body}")
  end

end
