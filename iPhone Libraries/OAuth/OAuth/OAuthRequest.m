//
//  OAuthRequest.m
//  OAuth
//
//  Created by Demi Raven on 7/10/10.
//  Copyright 2010 Bitsyrup, LLC. All rights reserved.
//

#import "OAuthRequest.h"
#import "OAuthUtility.h"

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
- (NSString *)url { return [NSString stringWithFormat:@"%@://%@%@%@%@%@%@",
                            [self scheme], 
                            [self host], 
                            ([[self port] intValue] != 0) ? @":" : @"", 
                            ([[self port] intValue] != 0) ? [NSString stringWithFormat:@"%i", [[self port] intValue]] : @"", 
                            [self path] ? [self path] : @"", 
                            [self query] ? @"?" : @"", 
                            [self query] ? [self query] : @""]; }
- (NSString *)scheme { return [url scheme]; }
- (NSString *)host { return [url host]; }
- (NSNumber *)port { return [url port]; }
- (NSString *)path { return [url path]; }
- (NSString *)query { return [url query]; }
- (NSDictionary *)getheaders { return headers; }

//Response-related get methods
- (NSInteger)statusCode { return [response statusCode]; }
- (NSString *)statusCodeAsString { 
    return [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]]; }
- (NSString *)responseHeader:(NSString *)key { return [[response allHeaderFields] objectForKey:key]; }

// Request-related set methods
- (void)setHeader:(NSString *)key to:(NSString *)value
{
  if (!headers) 
    headers = [[NSMutableDictionary alloc] init];
  [key retain];
  [value retain];
  [headers setValue:value forKey:key];
}

- (void)addHeadersToRequest
{
  if (headers)
  {
    NSArray * headerkeys = [headers allKeys];
    for (int i = 0; i < [headerkeys count]; i++)
    {
      NSString * headerkey = [headerkeys objectAtIndex:i];
      [request setValue:[headers valueForKey:headerkey] forHTTPHeaderField:headerkey];
    }
  }
}

- (void)setTimeout:(NSTimeInterval)tout
{
  [request setTimeoutInterval:tout ];
}

- (void)setBody:(NSData *)data asContentType:(NSString *)mimetype
{
  [data retain];
  [reqData release];
  reqData = data;
  [self setHeader:@"Content-Type" to:mimetype];
}

// Credential-related set methods
- (void)setConsumerCredentials:(NSString *)key secret:(NSString *)secret
{
  [key retain];
  [consumerKey release];
  [secret retain];
  [consumerSecret release];
  consumerKey = key;
  consumerSecret = secret;
}

- (void)setToken:(NSString *)tok secret:(NSString *)secret
{
  [tok retain];
  [token release];
  [secret retain];
  [tokenSecret release];
  token = tok;
  tokenSecret = secret;
}

- (NSDictionary *)paramsFromQuery:(NSString *)query
{
  NSMutableDictionary * params = [[[NSMutableDictionary alloc] init] autorelease];
  return params;
}

- (NSData *)doGenericRequest:(NSString *)method 
{
  if (request) [request release];
  request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setTimeoutInterval:(60 * 3)];
  [request setHTTPMethod:method];
  NSDictionary * params = [self paramsFromQuery:[self query]];
  if (reqData)
  {
    //TODO: add as param if xml-encoded form content
    [request setHTTPBody:reqData];
  }
  NSString * authheader = [OAuthUtility 
                           makeOAuthHeaderFromURL:[self url]
                           withMethod:method 
                           withToken:token 
                           withTokenSecret:tokenSecret 
                           withConsumerKey:consumerKey 
                           withConsumerSecret:consumerSecret 
                           withParameters:params];
  [self setHeader:@"Authorization" to:authheader];
  [self addHeadersToRequest];
  NSData * result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httperror];
  if (httperror)
  {
    NSLog(@"REQUEST ERROR: %@\n", [httperror localizedDescription]);
  }
  return result;
}

// Request action methods
- (NSData *)doPostRequest
{
  //TODO: refine, add asynch post
  return [self doGenericRequest:@"POST"];
}

- (NSData *)doGetRequest
{
  //TODO: refine, add asynch get
  return [self doGenericRequest:@"GET"];
}

- (NSData *)doPutRequest
{
  //TODO: refine, add verb=put query
  return [self doGenericRequest:@"PUT"];
}

- (NSData *)doDeleteRequest
{
  //TODO: refine, add verb=delete query
  return [self doGenericRequest:@"DELETE"];
}


@end
