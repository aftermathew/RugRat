//
//  RRQuestion.h
//  RugRat
//
//  Created by Demi Raven on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RRQuestion : NSObject {
	int questionID;
    NSString * questionText;
	int	startAgeWeeks;
	int endAgeWeeks;
	int version;
}
@property (nonatomic) int questionID;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic) int startAgeWeeks;
@property (nonatomic) int endAgeWeeks;
@property (nonatomic) int version;

// returns the URL of the response to this question
// in the local folder of web files
- (NSString*) responseURI;


@end
