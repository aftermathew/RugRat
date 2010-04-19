//
//  RRTopic.m
//  RugRat
//
//  Created by Demi Raven on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RRTopic.h"


@implementation RRTopic
@synthesize topicText;
@synthesize topicID;
@synthesize description;

- (id)initWithText:(NSString *)name
{
  if (self = [super init])
  {
    self.topicText = name;
  }
  return self;
}

- (id)initWithText:(NSString *)name withID:(int)ID andDescription: (NSString *)descriptionString
{
  if (self = [super init])
  {
	  self.topicText = name;
	  self.topicID = ID;
	  self.description = descriptionString;
  }
  return self;
}

- (void)dealloc 
{
	self.topicText = nil;
	self.description = nil;	
	[super dealloc];
}


@end
