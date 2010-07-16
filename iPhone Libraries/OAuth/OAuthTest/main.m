//
//  main.m
//  OAuthTest
//
//  Created by Demi Raven on 7/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthUtility.h"

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
  int retVal = UIApplicationMain(argc, argv, nil, nil);
  [pool release];
  
  return retVal;
}
