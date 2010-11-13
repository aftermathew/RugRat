//
//  RRBaby.m
//  RugRat
//
//  Created by Mathew Chasan on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRBaby.h"

static NSMutableArray* babies = nil;

@implementation RRBaby
@synthesize name;
@synthesize birthday;
@synthesize sex;
@synthesize birthHeight;
@synthesize birthWeight;

+(void) initialize
{
  if(! babies )
      babies = [[NSMutableArray alloc] initWithCapacity:5];
}

-(id) init{
    if (self = [super init]) {
        name = [[NSString alloc] init];
        sex = kSexGirl;
        birthday = [NSDate date];
        birthWeight = 3.5; //kg
        birthHeight = 50;  //cm
    }
    return self;
}

+ (RRBaby*) newBaby {
    RRBaby* newBabe = [[RRBaby alloc] init];
    [babies addObject:newBabe];
    return newBabe;
}

+ (int) numBabies {
    return [babies count];   
}

+ (NSArray*) getBabies {
    return (NSArray*) babies;
}

@end
