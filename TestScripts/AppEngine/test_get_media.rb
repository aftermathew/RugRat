#!/usr/bin/env ruby

require "net/https"
require "uri"

require "oauth.rb"
require "test_get_token.rb"
require 'pp'

@username = 'demi2'
@useremail = 'demi2@demi.com'
@userpassword = 'mydumbpassword'

@service_base_url = "rugrat-test.appspot.com"
@oauth_consumer_key = "xbzQDXehM0/JH1fjewisazXjmPw="
@oauth_consumer_secret = "UkgHVlhMYUC3TCVv/FcfrvzZUnqPyfu9lbAfUyE6qWg="

tg = TokenGetter.new()
tg.get
@token = tg.get_token
@tokensecret = tg.get_token_secret

service_path = "/assets/P3270008.jpg"
service_method = "GET"  
service_scheme = "http"	

oa = OAuth.new()
oa.consumer_key = @oauth_consumer_key
oa.consumer_secret = @oauth_consumer_secret
oa.token = @token
oa.token_secret = @tokensecret
#NOTE: no token, token secret in this call

uri = URI.parse("#{service_scheme}://#{@service_base_url}#{service_path}")
puts "\n"
puts uri
auth_header = oauth_generate_auth_header(oa, uri.to_s, "POST", nil)

puts "\n" + auth_header

http = Net::HTTP.new(uri.host, uri.port)
response, resp_body = http.get(uri.path, {'Authorization' => auth_header})

puts "\n" + response.code
puts "\n" + resp_body
