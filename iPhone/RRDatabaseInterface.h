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

#define DO_DB_TEST_ON_STARTUP 0
@interface RRDatabaseInterface : NSObject {
    sqlite3 *db;
    NSMutableArray *ageRangesArray;
    NSMutableArray *topicsArray;
}

+ (RRDatabaseInterface*) instance;
- (NSArray*) ageRanges;
- (NSArray*) topics;

// MATHEW
// this not needed but useful for debugging and helpful to me in writing more complicated queries
- (NSMutableArray*) questionsForAgeRange:(RRTimeRange*)range;

- (NSMutableArray*) topicsForAgeRange: (RRTimeRange*) range;
- (NSMutableArray*) questionsForAgeRange: (RRTimeRange*)range andTopic: (RRTopic*) topic;
- (NSMutableArray*) mediaForQuestion: (RRQuestion*) question;

@end
