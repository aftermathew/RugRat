//
//  RRMedia.h
//  RugRat
//
//  Created by Mathew Chasan on 4/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RRMedia : NSObject {
	int mediaID;
	NSString *mediaPath;
	NSString *description;
	NSString *type;
	NSString *extension;
}

@property (nonatomic) int mediaID;
@property (nonatomic, retain) NSString *mediaPath;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *extension;
@end
