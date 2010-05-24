#!/usr/bin/env ruby

require "net/https"
require "uri"

require "oauth.rb"
require 'pp'

@service_base_url = "rugrat-test.appspot.com"
@oauth_consumer_key = "9bA1Zh0AQpWM7DokAtYOZ3+DlkU="
@oauth_consumer_secret = "SIlpNqyxnQE/nDu6zVe6K2jZFWTxSRpd9dOml6IvYcE="

service_path = "/user"
service_method = "POST"  
service_scheme = "https"	

oa = OAuth.new()
oa.consumer_key = @oauth_consumer_key
oa.consumer_secret = @oauth_consumer_secret
#NOTE: no token, token secret in this call


uri = URI.parse("#{service_scheme}://#{@service_base_url}#{service_path}")
puts uri
auth_header = oauth_generate_auth_header(oa, uri.to_s, "POST", nil)

body = "<userAddRequest>"
body << "    <user>"
body << "        <name>Tester5</name>"
body << "        <email>tester5@gmail.com</email>"
body << "        <password>myt3sty</password>"
body << "    </user>"
body << "</userAddRequest>"

puts auth_header

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
response, resp_body = http.post(uri.path, body, {'Content-type' => 'text/xml;charset=utf-8', 'Authorization' => auth_header, 'Content-length' => '#{body.length}'})

puts response.code
puts response["Location"]
puts resp_body
