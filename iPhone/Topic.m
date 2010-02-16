//
//  Topic.m
//  RugRat
//
//  Created by Demi Raven on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Topic.h"


@implementation Topic
@synthesize topicName;
@synthesize topicID;

- (id)initWithName:(NSString *)name
{
  if (self = [super init])
  {
    self.topicName = name;
  }
  return self;
}

- (id)initWithName:(NSString *)name withID:(int)ID
{
  if (self = [super init])
  {
    self.topicName = name;
    self.topicID = ID;
  }
  return self;
}

- (void)dealloc 
{
  self.topicName = nil;
  [super dealloc];
}

@end
