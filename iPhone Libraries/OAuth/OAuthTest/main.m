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
  
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
  
    return retVal;
}
