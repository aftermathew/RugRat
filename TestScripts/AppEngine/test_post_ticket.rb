#!/usr/bin/env ruby

require "net/https"
require "uri"

require "oauth.rb"
require 'pp'

class TokenGetter

  def get()
  
    @username = 'demi'
    @useremail = 'demi@demi.com'
    @userpassword = 'mydumbpassword'

    @service_base_url = "rugrat-test.appspot.com"
    @oauth_consumer_key = "xbzQDXehM0/JH1fjewisazXjmPw="
    @oauth_consumer_secret = "UkgHVlhMYUC3TCVv/FcfrvzZUnqPyfu9lbAfUyE6qWg="
    
    service_path = "/auth/token"
    service_method = "POST"  
    service_scheme = "https"	
    
    oa = OAuth.new()
    oa.consumer_key = @oauth_consumer_key
    oa.consumer_secret = @oauth_consumer_secret
    #NOTE: no token, token secret in this call
    
    uri = URI.parse("#{service_scheme}://#{@service_base_url}#{service_path}")
    puts uri
    auth_header = oauth_generate_auth_header(oa, uri.to_s, "POST", nil)
    
    digest = base64_encode("#{@username}:#{@userpassword}")
    
    body = "<tokenRequest>"
    body << "    <digest>#{digest}</digest>"
    body << "</tokenRequest>"
    
    puts auth_header
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response, resp_body = http.post(uri.path, body, {'Content-type' => 'text/xml;charset=utf-8', 'Authorization' => auth_header, 'Content-length' => '#{body.length}'})
    
    puts response.code
    puts response["Location"]
    puts resp_body
    
    @token = resp_body.scan(/<token>([^<]+)<\/token>/)[0][0]
    @tokensecret = resp_body.scan(/<tokenSecret>([^<]+)<\/tokenSecret>/)[0][0]
    
  end

  def get_token
    @token
  end
  
  def get_token_secret
    @tokensecret
  end
end

class TicketGetter
  def get(token, token_secret)
    @service_base_url = "rugrat-test.appspot.com"
    @oauth_consumer_key = "xbzQDXehM0/JH1fjewisazXjmPw="
    @oauth_consumer_secret = "UkgHVlhMYUC3TCVv/FcfrvzZUnqPyfu9lbAfUyE6qWg="
    
    service_path = "/auth/ticket"
    service_method = "POST"  
    service_scheme = "https"	
    
    oa = OAuth.new()
    oa.consumer_key = @oauth_consumer_key
    oa.consumer_secret = @oauth_consumer_secret
    oa.token = token
    oa.token_secret = token_secret
    
    uri = URI.parse("#{service_scheme}://#{@service_base_url}#{service_path}")
    puts uri
    auth_header = oauth_generate_auth_header(oa, uri.to_s, "POST", nil)
    
    puts auth_header
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    body = ""
    response, resp_body = http.post(uri.path, body, {'Content-type' => 'text/xml;charset=utf-8', 'Authorization' => auth_header, 'Content-length' => '#{body.length}'})
    
    puts response.code
    puts response["Location"]
    puts resp_body
    
    @ticket = resp_body.scan(/<ticket>([^<]+)<\/ticket>/)[0][0]
    
  end
  
  def get_ticket
    return @ticket
  end
end

if __FILE__ == $0 then
  tg = TokenGetter.new()
  tg.get
  p tg.get_token
  p tg.get_token_secret
  ttg = TicketGetter.new()
  ttg.get(tg.get_token, tg.get_token_secret)
  p ttg.get_ticket
end