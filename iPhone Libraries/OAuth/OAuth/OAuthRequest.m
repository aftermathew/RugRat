//
//  OAuthRequest.m
//  OAuth
//
//  Created by Demi Raven on 7/10/10.
//  Copyright 2010 Bitsyrup, LLC. All rights reserved.
//

#import "OAuthRequest.h"

@implementation OAuthRequest

#pragma mark -
#pragma mark class instance methods

- (id) init 
{
  if(self = [super init])
  {
    //initialize members ...?
  }
  else
  {
    NSLog(@"Initialization failure, OAuthRequest.");
  }
  
  return self;
}

-(void)reset
{
  [url release];
  [request release];
  [response release];
  [headers release];
  [reqData release];
  [consumerKey release];
  [consumerSecret release]; 
}

- (id)initWithNSURL:(NSURL *)nsurl
{
  [self reset];
  [self init];
  [nsurl retain];
  url = nsurl;
  return self;
}

- (id)initWithString:(NSString *)urlString
{
  [self reset];
  [self init];
  url = [[[NSURL alloc] initWithString:urlString] retain];
  return self;
}

- (void)dealloc
{
  [self reset];
  [super dealloc];
}

//URL-related get methods
- (NSString *)url { return [NSString stringWithFormat:@"%@://%@%s%d/%@%s%@",
                            [self scheme], 
                            [self host], 
                            [self port] ? ":" : "", 
                            [self port], 
                            [self path], 
                            [self query] ? "?" : "", 
                            [self query]]; }
- (NSString *)scheme { return [url scheme]; }
- (NSString *)host { return [url host]; }
- (NSNumber *)port { return [url port]; }
- (NSString *)path { return [url path]; }
- (NSString *)query { return [url query]; }

//Response-related get methods
- (NSInteger)statusCode { return [response statusCode]; }
- (NSString *)statusCodeAsString { 
    return [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]; }
- (NSString *)responseHeader:(NSString *)key { return [[response allHeaderFields] objectForKey:key]; }

// Request-related set methods
- (void)setHeader:(NSString *)key to:(NSString *)value
{
  if (!headers) 
    headers = [[[NSDictionary alloc] init] retain];
  [headers setValue:value forKey:key];
}

- (void)setBody:(NSData *)data asContentType:(NSString *)mimetype
{
  [reqData release];
  [data retain];
  reqData = data;
  [self setHeader:@"Content-Type" to:mimetype];
}

// Credential-related set methods
- (void)setConsumerCredentials:(NSString *)key secret:(NSString *)secret
{
  [consumerKey release];
  [consumerSecret release];
  [key retain];
  [secret retain];
  consumerKey = key;
  consumerSecret = secret;
}

- (void)setToken:(NSString *)tok secret:(NSString *)secret
{
  [tok retain];
  [secret retain];
  token = tok;
  tokenSecret = secret;
}

// Request action methods
- (NSData *)doPostRequest
{
  //TODO: refine, add asynch post
  [request setHTTPMethod:@"POST"];
  [request setTimeoutInterval:(60 * 3)];
  return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httperror];
}

- (NSData *)doGetRequest
{
  [request setHTTPMethod:@"GET"];
  [request setTimeoutInterval:(60 * 3)];
  return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httperror];
}

- (NSData *)doPutRequest
{
  //TODO: refine, add verb=put query
  [request setHTTPMethod:@"PUT"];
  [request setTimeoutInterval:(60 * 3)];
  return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httperror];
}

- (NSData *)doDeleteRequest
{
  //TODO: refine, add verb=delete query
  [request setHTTPMethod:@"DELETE"];
  [request setTimeoutInterval:(60 * 3)];
  return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httperror];
}


@end
