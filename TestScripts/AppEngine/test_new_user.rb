#!/usr/bin/env ruby

require "net/https"
require "uri"

require "oauth.rb"
require 'pp'

@username = 'demi3'
@useremail = 'demi3@demi.com'
@userpassword = 'mydumbpassword'

@service_base_url = "rugrat-test.appspot.com"
@oauth_consumer_key = "xbzQDXehM0/JH1fjewisazXjmPw="
@oauth_consumer_secret = "UkgHVlhMYUC3TCVv/FcfrvzZUnqPyfu9lbAfUyE6qWg="

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
body << "        <name>#{@username}</name>"
body << "        <email>#{@useremail}</email>"
body << "        <password>#{@userpassword}</password>"
body << "    </user>"
body << "</userAddRequest>"

puts auth_header

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
response, resp_body = http.post(uri.path, body, {'Content-type' => 'text/xml;charset=utf-8', 'Authorization' => auth_header, 'Content-length' => '#{body.length}'})

puts response.code
puts response["Location"]
puts resp_body
