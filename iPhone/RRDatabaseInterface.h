//
//  RRDatabaseInterface.h
//  RugRat
//
//  Created by Mathew Chasan on 3/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "RRTimeRange.h"
#import "RRTopic.h"
#import "RRQuestion.h"

@interface RRDatabaseInterface : NSObject {
    sqlite3 *db;
	NSMutableArray *ageRangesArray;
}

+ (RRDatabaseInterface*) instance;
- (NSArray*) ageRanges;

// MATHEW
// this not needed but useful for debugging and helpful to me in writing more complicated queries
- (NSMutableArray*) questionsForAgeRange:(RRTimeRange*)range;

- (NSMutableArray*) topicsForAgeRange: (RRTimeRange*) range;
- (NSMutableArray*) questionsForAgeRange: (RRTimeRange*)range andTopic: (RRTopic*) topic;
- (NSMutableArray*) mediaForQuestion: (RRQuestion*) question;

@end
