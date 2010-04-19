//
//  RRTimeRange.h
//  RugRat
//
//  Created by Mathew Chasan on 3/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RRTimeRange : NSObject {
	int timeRangeID;
	int startWeek;
	int endWeek;
	NSString* name;
}

@property (nonatomic) int timeRangeID;
@property (nonatomic) int startWeek;
@property (nonatomic) int endWeek;
@property (nonatomic, retain) NSString * name;


@end
