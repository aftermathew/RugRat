//
//  main.m
//  OAuthTest
//
//  Created by Demi Raven on 7/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthUtility.h"
#import "OAuthRequest.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  
  NSString * test = [OAuthUtility parameterEncode:@"t~e0s[t^"];
  NSLog(@"result = %@", test);
  NSString * test2 = [OAuthUtility xmlEncode:@"\'\"<>012&amp;34\%"];
  NSLog(@"result2 = %@", test2);
  NSData * test3 = [test2 dataUsingEncoding:NSUTF8StringEncoding];
  NSString * b64str = [OAuthUtility base64Encode:test3];
  NSLog(@"result base64 encode = %@", b64str);
  test3 = [OAuthUtility base64Decode:b64str];
  NSString * test4 = [[NSString alloc] initWithData:test3 encoding:NSUTF8StringEncoding];
  NSLog(@"result base64 decode = %@", test4);
  NSString * test5 = @"This is a string to HMACSHA1";
  NSData * data5 = [test5 dataUsingEncoding:NSUTF8StringEncoding];
  NSString * key5 = @"stupid key";
  NSData * kdata5 = [key5 dataUsingEncoding:NSUTF8StringEncoding];
  NSLog(@"data = %@, key = %@", [[NSString alloc] initWithData:data5 encoding:NSUTF8StringEncoding],
        [[NSString alloc] initWithData:kdata5 encoding:NSUTF8StringEncoding]);
  NSLog(@"result HMACSHA1 as Base64 = %@", [OAuthUtility hashHMACSHA1AsBase64:data5 withKey:kdata5]);
  NSLog(@"return SHA1 base64 = %@", [OAuthUtility hashSHA1AsBase64:data5]);
  NSString * test6 = @"HTTP://www.Context.com:443/my/path?something=else";
  NSLog(@"result safe url = %@", [OAuthUtility makeOAuthSafeURLString:test6]);
  NSLog(@"current timestamp = %@", [OAuthUtility makeOAuthTimestampString]);
  NSLog(@"nonce = %@", [OAuthUtility makeOAuthNonceString]);
  NSLog(@"nonce = %@", [OAuthUtility makeOAuthNonceString]);
  NSLog(@"nonce = %@", [OAuthUtility makeOAuthNonceString]);
  NSLog(@"nonce = %@", [OAuthUtility makeOAuthNonceString]);
  NSLog(@"nonce = %@", [OAuthUtility makeOAuthNonceString]);
  NSString * conkey = @"xbzQDXehM0/JH1fjewisazXjmPw=";
  NSString * consec = @"UkgHVlhMYUC3TCVv/FcfrvzZUnqPyfu9lbAfUyE6qWg=";
  NSString * baseurl = @"https://rugrat-test.appspot.com/user";
  NSString * method = @"POST";
  NSString * authheader = [OAuthUtility makeOAuthHeaderFromURL:baseurl withMethod:method withToken:nil withTokenSecret:nil withConsumerKey:conkey withConsumerSecret:consec withParameters:nil];
  NSLog(@"auth header = %@", authheader);
  
  /*
  OAuthRequest * req = [[OAuthRequest alloc] initWithString:@"https://rugrat-test.appspot.com/user"];
  [req setConsumerCredentials:@"xbzQDXehM0/JH1fjewisazXjmPw=" secret:@"UkgHVlhMYUC3TCVv/FcfrvzZUnqPyfu9lbAfUyE6qWg="];
  NSMutableString * body = [[NSMutableString alloc] init];
  [body appendString:@"<userAddRequest>"];
  [body appendString:@"<user><name>"];
  [body appendString:@"testuser2</name><email>"];
  [body appendString:@"testuser2@testy.com</email><password>"];
  [body appendString:@"fakepass</password></user></userAddRequest>"];
  [req setBody:[body dataUsingEncoding:NSUTF8StringEncoding] asContentType:@"text/xml"];
  NSData * result = [req doPostRequest];
  NSLog(@"request url: %@\n", [req url]);
  NSDictionary * headers = [req getheaders];
  for (NSString * theKey in headers) {
    NSString * theVal = [headers objectForKey:theKey];
    NSLog(@"header %@ = %@\n", theKey, theVal);
  }
  NSLog(@"response status = %i\n", [req statusCode]);
  */
  
     
  
  
  int retVal = UIApplicationMain(argc, argv, nil, nil);
  [pool release];
  
  return retVal;
}
