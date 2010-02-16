//
//  Topic.h
//  RugRat
//
//  Created by Demi Raven on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Topic : NSObject {
  int topicID;
  NSString * topicName;
}

@property (nonatomic, retain) NSString * topicName;
@property (nonatomic) int topicID;

- (id) initWithName:(NSString *)name;
- (id) initWithName:(NSString *)name withID:(int)ID;

@end
