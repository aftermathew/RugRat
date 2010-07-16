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
  NSMutableString * newStr = [[NSMutableString alloc] init];
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
  NSMutableString * newStr = [[NSMutableString alloc] init];
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
  return [[NSString alloc] initWithCString:result];
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
  NSURL * url = [[NSURL alloc] initWithString:str];
  int portint = [[url port] intValue];
  NSString * port = (portint == 80 || portint == 443) ? @"" : [NSString stringWithFormat:@":%d", portint];
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

+ (NSString *)makeOAuthHeaderFromURL:(NSString *)url 
                          withMethod:(NSString *)method 
                           withToken:(NSString *)tok 
                     withTokenSecret:(NSString *)tokenSecret 
                     withConsumerKey:(NSString *)consumerKey 
                  withConsumerSecret:(NSString *)consumerSecret 
                      withParameters:(NSDictionary *)params
{
  //TODO
  return nil;
}



@end
