//
//  RRTopic.h
//  RugRat
//
//  Created by Demi Raven on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RRTopic : NSObject {
	int topicID;
	NSString * topicText;
	NSString * description;
}

@property (nonatomic, retain) NSString * topicText;
@property (nonatomic) int topicID;
@property (nonatomic, retain) NSString * description;


- (id) initWithText:(NSString *)name;
- (id) initWithText:(NSString *)name withID:(int)ID andDescription: (NSString *)descriptionString;

@end
