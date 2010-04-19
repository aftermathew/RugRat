//
//  RRQuestion.m
//  RugRat
//
//  Created by Demi Raven on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RRQuestion.h"


@implementation RRQuestion
@synthesize questionID;
@synthesize questionText;
@synthesize startAgeWeeks;
@synthesize endAgeWeeks;
@synthesize version;

- (NSString*) responseURI{
	// TODO
	return @"http://google.com";
}

@end
