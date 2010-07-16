#!/usr/bin/env ruby

#OAUTH library for Ruby

require "cgi"
require "base64"
require "openssl"
require "digest"
require "uri"

class OAuth
  
  attr :token, ""
  attr :token_secret, ""
  attr :consumer_key, ""
  attr :consumer_secret, ""
  
end

def parameter_encode(in_str)
  unreserved = "_-.~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  out_str = ""
  in_str.each_char do |c|
    out_str << ((unreserved.include? c) ? c : "%#{c[0]}" )
  end if in_str
  out_str
end

def xml_encode(in_str)
  CGI.escapeHTML(in_str)
end

def base64_encode(in_str)
  Base64.encode64(in_str).chomp
end

def base64_decode(in_str)
  Base64.decode64(in_str)
end

def hash_HMACSHA1(in_key, in_data)
  dig = OpenSSL::Digest::Digest.new('sha1')
  OpenSSL::HMAC.digest(dig, in_key, in_data)
end

def hash_HMACSHA1_as_b64(in_key, in_data)
  Base64.encode64(hash_HMACSHA1(in_key, in_data))
end

def hash_SHA1_as_b64(in_data)
  Base64.encode64(Digest::SHA1.digest(in_data))
end

def oauth_url(url)
  uri = URI.parse(url)
  port = (uri.port == 80 || uri.port == 443) ? "" : ":#{uri.port}"
  uri.scheme.downcase + "://" + uri.host.downcase + port + uri.path
end

def oauth_timestamp()
  Time.now.gmtime.to_i.to_s
end

def oauth_nonce()
  salt = Array.new(6) { rand(256) }.pack('C*').unpack('H*').first
  time_str = Time.now.getutc.strftime('%Y-%m-%dT%H:%M:%SZ')
  base64_encode(salt + time_str).chomp
end

#returns hash - key oauth_signature has result
def oauth_generate_signature(oauth_obj, url, method, params)
  oauth_url = oauth_url(url)
  oauth_method = method.upcase
  oauth_params = {}
  oauth_params["oauth_version"] = '1.0' 
  oauth_params["oauth_signature_method"] = 'HMAC-SHA1'
  oauth_params["oauth_nonce"] = oauth_nonce()
  oauth_params["oauth_timestamp"] = oauth_timestamp()
  oauth_params["oauth_consumer_key"] = oauth_obj.consumer_key if oauth_obj.consumer_key
  oauth_params["oauth_token"] = oauth_obj.token if oauth_obj.token
  if params then
    params.keys.each do |key|
      oauth_params[key] = parameter_encode(params[key])
    end
  end
  normalized_base_string = ''
  oauth_params.keys.sort.each do |key|
    normalized_base_string << parameter_encode(key) + '=' + parameter_encode(oauth_params[key]) + '&'
  end
  normalized_base_string.chop! #trailing &
  #puts "normalized_base_string: " + normalized_base_string
  signature_base_string = parameter_encode(oauth_method) + '&' + \
    parameter_encode(oauth_url) + '&' + \
    parameter_encode(normalized_base_string)
  #puts "signature_base_string: " + signature_base_string
  signature_key = parameter_encode(oauth_obj.consumer_secret) + \
    '&' + parameter_encode(oauth_obj.token_secret)
  #puts signature_key
  oauth_signature = hash_HMACSHA1_as_b64(signature_key, signature_base_string)
  #puts "signature: " + oauth_signature
  oauth_params["oauth_signature"] = oauth_signature
  oauth_params
end

def oauth_generate_auth_header(oauth_obj, url, method, params)
  oauth_params = oauth_generate_signature(oauth_obj, url, method, params)
  auth_header = "OAuth"
  auth_header << " oauth_consumer_key=\"#{parameter_encode(oauth_obj.consumer_key)}\", " if oauth_obj.consumer_key
  auth_header << " oauth_token=\"#{parameter_encode(oauth_obj.token)}\", " if oauth_obj.token
  auth_header << " oauth_signature_method=\"HMAC-SHA1\", "
  auth_header << " oauth_signature=\"#{parameter_encode(oauth_params["oauth_signature"])}\", "
  auth_header << " oauth_timestamp=\"#{oauth_params["oauth_timestamp"]}\", "
  auth_header << " oauth_nonce=\"#{parameter_encode(oauth_params["oauth_nonce"])}\", "
  auth_header << " oauth_version=\"1.0\""
  auth_header
end
