#!/usr/bin/env ruby

require "net/https"
require "uri"


uri = URI.parse("http://google.com")
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
request.initialize_http_header({"User-Agent" => "My Ruby Script"})

response = http.request(request)
puts response.code
puts response["location"]
