//
//  OAuthUtility.m
//  OAuth
//
//  Created by Demi Raven on 7/10/10.
//  Copyright 2010 Bitsyrup, LLC. All rights reserved.
//

#import "OAuthUtility.h"
#import "NSData+Base64.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

@implementation OAuthUtility

const char * reservedParamChars = "_-.~abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
const char * base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (NSString *)parameterEncode:(NSString *)encodableString
{
  if (!encodableString) return nil;
  const char * baseUTF8Str = [encodableString cStringUsingEncoding:NSUTF8StringEncoding];
  int reservedLen = strlen(reservedParamChars);
  int baseLen = strlen(baseUTF8Str);
  NSMutableString * newStr = [[[NSMutableString alloc] init] autorelease];
  for (int i = 0; i < baseLen; i++)
  {
    char val = 0;
    for (int j = 0; j < reservedLen; j++)
    {
      if (reservedParamChars[j] == baseUTF8Str[i])
      {
        val = baseUTF8Str[i];
        break;
      }
    }
    if (val)
    {
      [newStr appendString:[NSString stringWithFormat:@"%c", val]];
    }
    else 
    {
      [newStr appendString:[NSString stringWithFormat:@"%%%02i", baseUTF8Str[i]]];
    }
  }
  return newStr;
}

+ (NSString *)xmlEncode:(NSString *)encodableString
{
  if (!encodableString) return nil;
  const char * baseUTF8Str = [encodableString cStringUsingEncoding:NSUTF8StringEncoding];
  int baseLen = strlen(baseUTF8Str);
  NSMutableString * newStr = [[[NSMutableString alloc] init] autorelease];
  for (int i = 0; i < baseLen; i++)
  {
    char val = baseUTF8Str[i];
    if (val < 0x09 || val == 0x0B || val == 0x0C ||
        (val > 0x0D && val < 0x20) || val > 0x7E)
    {
      [newStr appendString:[NSString stringWithFormat:@"&#%02i;", val]];
    }
    else 
    {
      NSString * result;
      switch (val)
      {
        case 34: //"
          result = @"&quot;"; break;
        case 38: //&
          result = @"&amp;"; break;
        case 39: //'
          result = @"&apos;"; break;
        case 60: //<
          result = @"&lt;"; break;
        case 62: //>
          result = @"&gt;"; break;
        default:
          result = [NSString stringWithFormat:@"%c", val];
      }
      [newStr appendString:result];
    }
  }
  return newStr;
}

+ (NSString *)base64Encode:(NSData *)data
{
  char * result = NewBase64Encode([data bytes], [data length], 0, 0);
  return [[[NSString alloc] initWithCString:result] autorelease];
}

+ (NSData *)base64Decode:(NSString *)encodableString
{
  return [NSData dataFromBase64String:encodableString];
}

+ (NSData *)hashHMACSHA1:(NSData *)subjectData withKey:(NSData *)key
{
  uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
  CCHmacContext hmacContext;
  CCHmacInit(&hmacContext, kCCHmacAlgSHA1, [key bytes], [key length]);
  CCHmacUpdate(&hmacContext, [subjectData bytes], [subjectData length]);
  CCHmacFinal(&hmacContext, digest);
  return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

+ (NSString *)hashHMACSHA1AsBase64:(NSData *)subjectData withKey:(NSData *)key
{
  return [self base64Encode:[self hashHMACSHA1:subjectData withKey:key]];
}

+ (NSString *)hashSHA1AsBase64:(NSData *)subjectData
{
  uint8_t hash[CC_SHA1_DIGEST_LENGTH] = {0};
  CC_SHA1_CTX sha1Context;
  CC_SHA1_Init(&sha1Context);
  CC_SHA1_Update(&sha1Context, [subjectData bytes], [subjectData length]);
  CC_SHA1_Final(hash, &sha1Context);
  return [self base64Encode:[NSData dataWithBytes:hash length:CC_SHA1_DIGEST_LENGTH]];
}

+ (NSString *)makeOAuthSafeURLString:(NSString *)str
{
  NSURL * url = [[[NSURL alloc] initWithString:str] autorelease];
  int portint = [[url port] intValue];
  NSString * port = (portint == 80 || portint == 443 || portint == 0) ? @"" : [NSString stringWithFormat:@":%d", portint];
  return [NSString stringWithFormat:@"%@://%@%@%@", 
          [[url scheme] lowercaseString],
          [[url host] lowercaseString],
          port,
          [url path]];
}

+ (NSString *)makeOAuthTimestampString
{
  return [NSString stringWithFormat:@"%lu", (long)[[NSDate date] timeIntervalSince1970]];
}

+ (NSString *)makeOAuthNonceString
{
  return [self hashSHA1AsBase64:[[NSString stringWithFormat:@"%lf", [[NSDate date] timeIntervalSince1970]] dataUsingEncoding:NSASCIIStringEncoding]];
}

+ (NSString *)makeOAuthSignature:(NSString *)url 
                      withMethod:(NSString *)method 
                  withParameters:(NSDictionary *)params
             withOAuthParameters:(NSDictionary *)oauthparams
{
  NSMutableDictionary * allparams = [[NSMutableDictionary alloc] init];
  //add params to allparams, parameter encoded
  NSEnumerator * paramsenum = [params keyEnumerator];
  NSString * key;
  while (nil != (key = [paramsenum nextObject])) 
  {
    [allparams setValue:[OAuthUtility parameterEncode:[params valueForKey:key]] forKey:[OAuthUtility parameterEncode:key]];
  }
  //add oauthparams to allparams
  NSEnumerator * paramsenum2 = [oauthparams keyEnumerator];
  while (nil != (key = [paramsenum2 nextObject]))
  {
    NSString * pkey = [OAuthUtility parameterEncode:key];
    NSString * pval = [OAuthUtility parameterEncode:[oauthparams valueForKey:key]];
    NSLog(@"adding key/val to dictionary: %@ / %@\n", pkey, pval);
    if (NSNotFound == [pkey rangeOfString:@"secret"].location)
      [allparams setValue:pval forKey:pkey];
  }
  //sort allparams keys
  NSArray * sortedparamskeys = [[allparams allKeys] sortedArrayUsingSelector:@selector(localizedCompare:)];
  //build normalized base string
  NSMutableString * normalizedbasestr = [[NSMutableString alloc] init];
  for (int i = 0; i< [sortedparamskeys count]; i++)
  {
    NSString * curkey = [sortedparamskeys objectAtIndex:i];
    if ([allparams valueForKey:curkey])
    {
      [normalizedbasestr appendFormat:@"%@=%@%s", curkey, [allparams valueForKey:curkey], (i == ([sortedparamskeys count] - 1)) ? "" : "&"];
      NSLog(@"current normalized base str: %@\n", normalizedbasestr );
    }
  }
  //get signature base string
  NSString * signaturebasestr = [NSString stringWithFormat:@"%@&%@&%@",
                                  [OAuthUtility parameterEncode:[method uppercaseString]],
                                  [OAuthUtility parameterEncode:[OAuthUtility makeOAuthSafeURLString:url]],
                                  [OAuthUtility parameterEncode:normalizedbasestr]];
  NSLog(@"signature base string = %@\n", signaturebasestr);
  [normalizedbasestr release];
  //get signature key
  NSString * consumer_secret = [oauthparams valueForKey:@"oauth_consumer_secret"];
  NSString * pcs = (consumer_secret != nil) ? [OAuthUtility parameterEncode:consumer_secret] : nil;
  NSString * token_secret = [oauthparams valueForKey:@"oauth_token_secret"];
  NSString * pts = (token_secret != nil) ? [OAuthUtility parameterEncode:token_secret] : nil;
  NSString * signaturekey = [NSString stringWithFormat:@"%@&%@", (pcs != nil) ? pcs : @"", (pts != nil) ? pts : @""];
  NSLog(@"signature key = %@\n", signaturekey);
  NSData * basedata = [signaturebasestr dataUsingEncoding:NSUTF8StringEncoding];
  NSData * basekey = [signaturekey dataUsingEncoding:NSUTF8StringEncoding];
  NSString * retval = [OAuthUtility hashHMACSHA1AsBase64:basedata withKey:basekey];
  NSLog(@"return value = %@\n", retval);
  return [NSString stringWithString:retval];
}

+ (NSString *)makeOAuthHeaderFromURL:(NSString *)url 
                          withMethod:(NSString *)method 
                           withToken:(NSString *)tok 
                     withTokenSecret:(NSString *)tokenSecret 
                     withConsumerKey:(NSString *)consumerKey 
                  withConsumerSecret:(NSString *)consumerSecret 
                      withParameters:(NSDictionary *)params
{
  NSMutableDictionary * oauthparams = [[NSMutableDictionary alloc] init];
  [oauthparams setValue:@"1.0" forKey:@"oauth_version"];
  [oauthparams setValue:@"HMAC-SHA1" forKey:@"oauth_signature_method"];
  [oauthparams setValue:[OAuthUtility makeOAuthNonceString] forKey:@"oauth_nonce"];
  [oauthparams setValue:[OAuthUtility makeOAuthTimestampString] forKey:@"oauth_timestamp"];
  if (nil != tok) [oauthparams setValue:tok forKey:@"oauth_token"];
  if (nil != consumerKey) [oauthparams setValue:consumerKey forKey:@"oauth_consumer_key"];
  if (nil != tokenSecret) [oauthparams setValue:tokenSecret forKey:@"oauth_token_secret"];
  if (nil != consumerSecret) [oauthparams setValue:consumerSecret forKey:@"oauth_consumer_secret"];
  NSString * signature = [OAuthUtility makeOAuthSignature:url withMethod:method withParameters:params withOAuthParameters:oauthparams];
  NSLog(@"sig = %@\n", signature);
  NSLog(@"retain count = %i\n", [signature retainCount]);
  [oauthparams setValue:signature forKey:@"oauth_signature"];
  NSMutableString * header = [[[NSMutableString alloc] init] autorelease];
  [header appendString:@"OAuth "];
  if (nil != [oauthparams objectForKey:@"oauth_consumer_key"]) 
    [header appendFormat:@"oauth_consumer_key=\"%@\", ", [oauthparams objectForKey:@"oauth_consumer_key"]];
  if (nil != [oauthparams objectForKey:@"oauth_token"])
    [header appendFormat:@"oauth_token=\"%@\", ", [oauthparams objectForKey:@"oauth_token"]];
  [header appendFormat:@"oauth_signature_method=\"%@\", ", [oauthparams objectForKey:@"oauth_signature_method"]];
  [header appendFormat:@"oauth_signature=\"%@\", ", [oauthparams objectForKey:@"oauth_signature"]];
  [header appendFormat:@"oauth_timestamp=\"%@\", ", [oauthparams objectForKey:@"oauth_timestamp"]];
  [header appendFormat:@"oauth_nonce=\"%@\", ", [oauthparams objectForKey:@"oauth_nonce"]];
  [header appendFormat:@"oauth_version=\"%@\"", [oauthparams objectForKey:@"oauth_version"]];
  [oauthparams release];
  return header;
}



@end
