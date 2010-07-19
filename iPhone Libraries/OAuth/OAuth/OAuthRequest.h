//
//  OAuthRequest.h
//  OAuth
//
//  Created by Demi Raven on 7/10/10.
//  Copyright 2010 Bitsyrup, LLC. All rights reserved.
//

// ***EXAMPLE***
// OAuthRequest * req = [[OAuthRequest alloc] initWithString:@"https://myserver.com/my/path"];
// [req setConsumerCredentials:myCKey secret:myCSecret];
// [req setToken:myToken secret:myTokenSecret];
// [req setHeader:@"Monkey" to:@"Colobus"];
// [req setBody:myNSData asContentType:@"text/plain"];
// NSData * respData = [req doPostRequest];
// NSInteger respCode = [req getResponseCode];
//
// NSString * responseString = [[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding];


#import <Foundation/Foundation.h>


@interface OAuthRequest : NSObject {
  NSURL * url;                    //URL (incl scheme, port, resource, query etc.)
  NSMutableURLRequest * request;  //request obj
  NSHTTPURLResponse * response;   //response obj
  NSError * httperror;
  NSMutableDictionary * headers;         //headers to append to request
  NSData * reqData;               //request body param data UTF8
  NSString * consumerKey;
  NSString * consumerSecret;
  NSString * token;               //request token
  NSString * tokenSecret;         //request token secret
}

//init 
- (id)initWithNSURL:(NSURL *)nsurl;
- (id)initWithString:(NSString *)urlString;

//getters
// NSURL - related
- (NSString *)url;
- (NSString *)scheme;
- (NSString *)host;
- (NSNumber *)port;
- (NSString *)path;
- (NSString *)query;
// NSHTTPURLResponse - related
- (NSInteger)statusCode;
- (NSString *)statusCodeAsString;
- (NSString *)responseHeader:(NSString *)key;

//setters
// Request headers
- (void)setHeader:(NSString *)key to:(NSString *)value;
// Request content
- (void)setBody:(NSData *)data asContentType:(NSString *)mimetype;
// OAuth credentials
- (void)setConsumerCredentials:(NSString *)key secret:(NSString *)secret;
- (void)setToken:(NSString *)tok secret:(NSString *)secret; 

//request methods
- (NSData *)doPostRequest;
- (NSData *)doGetRequest;
- (NSData *)doPutRequest;         //may not be supported by some servers
- (NSData *)doDeleteRequest;      //may not be supported by some servers

@end
