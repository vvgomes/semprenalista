require 'net/http'
require 'uri'

class HttpClient
  
  def get resource
    uri = URI.parse resource
    Net::HTTP.start(uri.host, uri.port) do |http|
      http.get resource
    end
  end
  
  def post service, data
    uri = URI.parse service
    Net::HTTP.post_form uri, data
  end
  
end