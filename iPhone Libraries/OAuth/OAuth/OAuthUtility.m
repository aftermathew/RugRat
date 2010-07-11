//
//  OAuthUtility.m
//  OAuth
//
//  Created by Demi Raven on 7/10/10.
//  Copyright 2010 Bitsyrup, LLC. All rights reserved.
//

#import "OAuthUtility.h"
#import "NSData+Base64.h"

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
  NSString * retStr = [[NSString alloc] initWithCString:result];
  return retStr;
}

+ (NSData *)base64Decode:(NSString *)encodableString
{
  return [NSData dataFromBase64String:encodableString];
}

+ (NSData *)hashHMACSHA1:(NSData *)subjectData withKey:(NSData *)key
{
  return nil;
}

+ (NSString *)hashHMACSHA1AsBase64:(NSData *)subjectData withKey:(NSData *)key
{
  return nil;
}

+ (NSString *)hashSHA1AsBase64:(NSData *)subjectData
{
  return nil;
}

+ (NSString *)makeOAuthSafeURLString:(NSString *)url
{
  return nil;
}

+ (NSString *)makeOAuthTimestampString
{
  return nil;
}

+ (NSString *)makeOAuthNonceString
{
  return nil;
}

+ (NSString *)makeOAuthHeaderFromURL:(NSString *)url 
                          withMethod:(NSString *)method 
                           withToken:(NSString *)tok 
                     withTokenSecret:(NSString *)tokenSecret 
                     withConsumerKey:(NSString *)consumerKey 
                  withConsumerSecret:(NSString *)consumerSecret 
                      withParameters:(NSDictionary *)params
{
  return nil;
}



@end
