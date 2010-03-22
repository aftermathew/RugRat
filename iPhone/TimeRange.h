//
//  TimeRange.h
//  RugRat
//
//  Created by Mathew Chasan on 3/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TimeRange : NSObject {
	int m_startWeek;
	int m_endWeek;
	NSString* m_name;
}

@property (nonatomic, retain) NSString * m_name;
@property (nonatomic) int m_startWeek;
@property (nonatomic) int m_endWeek;

@end
