//
//  OAuthUtility.h
//  OAuth
//
//  Created by Demi Raven on 7/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OAuthUtility : NSObject {

}

+ (NSString *)parameterEncode:(NSString *)encodableString;  //stringent percent encoding
+ (NSString *)xmlEncode:(NSString *)encodableString;        //standard entity encoding
+ (NSString *)base64Encode:(NSData *)data;
+ (NSData *)base64Decode:(NSString *)encodableString;
+ (NSData *)hashHMACSHA1:(NSData *)subjectData withKey:(NSData *)key;
+ (NSString *)hashHMACSHA1AsBase64:(NSData *)subjectData withKey:(NSData *)key;
+ (NSString *)hashSHA1AsBase64:(NSData *)subjectData;
+ (NSString *)makeOAuthSafeURLString:(NSString *)url;
+ (NSString *)makeOAuthTimestampString;
+ (NSString *)makeOAuthNonceString;
+ (NSString *)makeOAuthHeaderFromURL:(NSString *)url withMethod:(NSString *)method withToken:(NSString *)tok withTokenSecret:(NSString *)tokenSecret withConsumerKey:(NSString *)consumerKey withConsumerSecret:(NSString *)consumerSecret withParameters:(NSDictionary *)params;

@end
