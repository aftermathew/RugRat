//
//  RRDatabaseInterface.m
//  RugRat
//
//  Created by Mathew Chasan on 3/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// Singleton class based on this stack overflow thread...

#import "RRDatabaseInterface.h"
#import "RRLog.h"

static RRDatabaseInterface *gInstance = NULL;


@implementation RRDatabaseInterface

#pragma mark -
#pragma mark class instance methods

- (void)openQuestionsDB {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rugrat_db" ofType:@"sqlite"];
    int dbrc = sqlite3_open([path UTF8String], &db);
    if (dbrc == SQLITE_OK) {
        LOG_DEBUG(@"Database Successfully Opened :) ");
    } else {
        LOG_ERROR(@"Error in opening database :( ");
        db = nil;
    }
}


// MATHEW:
// kept this code in case we ever decide to add
// functionality to re-open a newly downloaded
// DB or something of that nature, but for now
// this function not needed as this class is a
// singleton.
//
// - (void)closeQuestionsDB {
//   if (nil != db)
//   {
//     dbrc = sqlite3_close(db);
//     if (dbrc == SQLITE_OK)
//     {
//       NSLog(@"Database closed.");
//       db = nil;
//     }
//     else
//     {
//       LOG_ERROR(@"Database closing failure. %i", dbrc);
//     }
//   }
// }

- (void) loadDataFromDb {
    [self ageRanges];

    // A little test to output what I have in my db..
#if DO_DB_TEST_ON_STARTUP
    for (int i = 0; i < [ageRangesArray count]; i++) {
        [self questionsForAgeRange:(RRTimeRange*)[ageRangesArray objectAtIndex:i]];
        [self topicsForAgeRange:(RRTimeRange*)[ageRangesArray objectAtIndex:i]];
    }

    [self topics];
    for (int i = 0; i < [ageRangesArray count]; i++) {
        for (int j = 0; j < [topicsArray count]; j++) {
            [self questionsForAgeRange:(RRTimeRange*)[ageRangesArray objectAtIndex:i]
                  andTopic:(RRTopic*)[topicsArray objectAtIndex:j]];
        }
    }

#endif
}


- (id) init {
    if(self = [super init]){
        // initialise the database here.
        [self openQuestionsDB];
        ageRangesArray = nil;
    }

    [self loadDataFromDb];

    return self;
}




- (NSArray*) ageRanges{
    if(db == nil){
        LOG_ERROR(@"Tried to get get age ranges from an nil DB!");
        return nil;
    }

    if(ageRangesArray == nil){
        // create a place to store our ages
        ageRangesArray = [[[NSMutableArray alloc] init] retain];

        //query database for all ages
        const char *mySelect = "select * from AgeRanges";
        sqlite3_stmt * statement;
        int dbrc = sqlite3_prepare_v2 (db, mySelect, -1, &statement, NULL);

        if(dbrc != SQLITE_OK){
            LOG_ERROR(@"Ages query returned a failed result: %d", dbrc);
            return nil;
        }
        // parse the query into an array
        while (sqlite3_step(statement) == SQLITE_ROW)
            {
                RRTimeRange * timeRange = [[RRTimeRange alloc] init];
                timeRange.timeRangeID = (int) sqlite3_column_int(statement, 0);
                timeRange.startWeek	  =	(int) sqlite3_column_int(statement, 1);
                timeRange.endWeek     =	(int) sqlite3_column_int(statement, 2);
                timeRange.name = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(statement, 3)];

                LOG_INFO(@"Adding ageRange :: %@ : from: %d to %d weeks.", [timeRange name], [timeRange startWeek], [timeRange endWeek]);
                [ageRangesArray addObject:timeRange];
            }

        // cleanup the query
        sqlite3_finalize(statement);

        LOG_INFO(@"db read, %i age ranges.", [ageRangesArray count]);
    }

    return ageRangesArray;
}


- (NSArray*) topics{
    if(db == nil){
        LOG_ERROR(@"Tried to topics from an nil DB!");
        return nil;
    }

    if(topicsArray == nil){
        // create a place to store our topics
        topicsArray = [[[NSMutableArray alloc] init] retain];

        //query database for all ages
        const char *mySelect = "select * from Topics";
        sqlite3_stmt * statement;
        int dbrc = sqlite3_prepare_v2 (db, mySelect, -1, &statement, NULL);

        if(dbrc != SQLITE_OK){
            LOG_ERROR(@"Ages query returned a failed result: %d", dbrc);
            return nil;
        }
        // parse the query into an array
        while (sqlite3_step(statement) == SQLITE_ROW){
            RRTopic* topic = [[RRTopic alloc] init];
            topic.topicID  = (int) sqlite3_column_int(statement, 0);
            topic.topicText  = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(statement, 1)];
            topic.description = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(statement, 2)];

            LOG_INFO(@"Adding Topic :: %@ : %@",topic.topicText, topic.description);
            [topicsArray addObject:topic];
        }

        // cleanup the query
        sqlite3_finalize(statement);

        LOG_INFO(@"db read, %i topics.", [topicsArray count]);
    }

    return topicsArray;
}



- (NSMutableArray*) topicsForAgeRange: (RRTimeRange*) range{
    NSMutableArray *topics = [[[NSMutableArray alloc] init] autorelease];

    // find all topics
    // where there exists a question for in that topic
    // where the question start age is >= to the age range start age and <= to the age range end age OR
    // where the question endWeeks is <= to the ageRange endWeeks and the >= the ageRange startAge
    NSString *queryFormat =
        @"SELECT * FROM Topics WHERE Id IN ("
	" SELECT DISTINCT QuestionTopics.TopicId FROM Questions "
	"  INNER JOIN QuestionTopics ON Questions.Id=QuestionTopics.QuestionId "
	"    AND ((StartAgeWeeks BETWEEN %d AND %d) OR "
	"         (EndAgeWeeks BETWEEN %d AND %d)   OR "
	"         (StartAgeWeeks < %d AND EndAgeWeeks > %d))"
        ")";

    NSString *query = [NSString stringWithFormat:queryFormat,
                                range.startWeek, range.endWeek,
                                range.startWeek, range.endWeek,
                                range.startWeek, range.endWeek];


    sqlite3_stmt * statement;
    int dbrc = sqlite3_prepare_v2 (db, [query UTF8String], -1, &statement, NULL);

    if(dbrc != SQLITE_OK){
        LOG_ERROR(@"topicsForAgeRange query returned a failed result: %d", dbrc);
        return nil;
    }
    // parse the query into an array
    while (sqlite3_step(statement) == SQLITE_ROW)
	{
            RRTopic* topic = [[RRTopic alloc] init];
            topic.topicID  = (int) sqlite3_column_int(statement, 0);
            topic.topicText  = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(statement, 1)];
            topic.description = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(statement, 2)];


            LOG_INFO(@"Found topicForAgeRange: %@ :: %@ : %@", range.name, topic.topicText, topic.description);
            [topics addObject:topic];
	}

    // cleanup the query
    sqlite3_finalize(statement);

    return topics;
}

- (NSMutableArray*) questionsForAgeRange:(RRTimeRange*)range {

    NSMutableArray *questions = [[[NSMutableArray alloc] init] autorelease];

    // find all questions
    // where the question start age is >= to the age range start age and <= to the age range end age OR
    // where the question endWeeks is <= to the ageRange endWeeks and the >= the ageRange startAge
    NSString *queryFormat =
        @"SELECT * FROM Questions WHERE ((StartAgeWeeks  BETWEEN %d AND %d) "
        " OR (EndAgeWeeks BETWEEN %d AND  %d) "
        " OR (StartAgeWeeks < %d AND EndAgeWeeks > %d))";
    NSString *query = [NSString stringWithFormat:queryFormat,
                                range.startWeek, range.endWeek,
                                range.startWeek, range.endWeek,
                                range.startWeek, range.endWeek];


    sqlite3_stmt * statement;
    int dbrc = sqlite3_prepare_v2 (db, [query UTF8String], -1, &statement, NULL);

    if(dbrc != SQLITE_OK){
        LOG_ERROR(@"questionsForAgeRange query returned a failed result: %d", dbrc);
        return nil;
    }
    // parse the query into an array
    while (sqlite3_step(statement) == SQLITE_ROW)
	{
            RRQuestion * question = [[RRQuestion alloc] init];
            question.questionID    = (int) sqlite3_column_int(statement, 0);
            question.questionText  = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(statement, 1)];
            question.startAgeWeeks = (int) sqlite3_column_int(statement, 2);
            question.endAgeWeeks   = (int) sqlite3_column_int(statement, 3);
            question.version       = (int) sqlite3_column_int(statement, 4);


            LOG_INFO(@"Found questionForAgeRange: %@ ::  %@", range.name, question.questionText);
            [questions addObject:question];
	}

    // cleanup the query
    sqlite3_finalize(statement);

    return questions;
}

- (NSMutableArray*) questionsForAgeRange:(RRTimeRange*)range andTopic:(RRTopic*)topic{
    NSMutableArray *questions = [[[NSMutableArray alloc] init] autorelease];

    // find all questions
    // where the question start age is >= to the age range start age and <= to the age range end age OR
    // where the question endWeeks is <= to the ageRange endWeeks and the >= the ageRange startAge
    // and the topic matches the topic given
    NSString *queryFormat =
	@"SELECT Questions.* FROM Questions "
	" INNER JOIN QuestionTopics ON  Questions.Id=QuestionTopics.QuestionId "
	" AND QuestionTopics.TopicId=%d AND "
	"   ((StartAgeWeeks BETWEEN %d AND %d) OR "
	"    (EndAgeWeeks BETWEEN %d AND %d)   OR "
	"    (StartAgeWeeks < %d AND EndAgeWeeks > %d))";

    NSString *query = [NSString stringWithFormat:queryFormat,
                                topic.topicID,
                                range.startWeek, range.endWeek,
                                range.startWeek, range.endWeek,
                                range.startWeek, range.endWeek];


    sqlite3_stmt * statement;
    int dbrc = sqlite3_prepare_v2 (db, [query UTF8String], -1, &statement, NULL);

    if(dbrc != SQLITE_OK){
        LOG_ERROR(@"QuestionsForAgeRangeAndTopic query returned a failed result: %d", dbrc);
        return nil;
    }
    // parse the query into an array
    while (sqlite3_step(statement) == SQLITE_ROW)
	{
            RRQuestion * question = [[RRQuestion alloc] init];
            question.questionID    = (int) sqlite3_column_int(statement, 0);
            question.questionText  = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_text(statement, 1)];
            question.startAgeWeeks = (int) sqlite3_column_int(statement, 2);
            question.endAgeWeeks   = (int) sqlite3_column_int(statement, 3);
            question.version       = (int) sqlite3_column_int(statement, 4);


            LOG_INFO(@"Found questionForAgeRange: %@ andTopic: %@ :: %@", range.name, topic.topicText, question.questionText);
            [questions addObject:question];
	}

    // cleanup the query
    sqlite3_finalize(statement);

    return questions;

}


- (NSMutableArray*) mediaForQuestion: (RRQuestion*) question{
    NSMutableArray *media = [[[NSMutableArray alloc] init] autorelease];






    return media;
}








#pragma mark -
#pragma mark Singleton methods

+ (RRDatabaseInterface*)instance
{
    @synchronized(self)
        {
            if (gInstance == nil)
                gInstance = [[RRDatabaseInterface alloc] init];
        }
    return gInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (gInstance == nil) {
            gInstance = [super allocWithZone:zone];
            return gInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing as this is a singlton
}

- (id)autorelease {
    return self;
}



@end
