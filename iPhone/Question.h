//
//  Question.h
//  RugRat
//
//  Created by Demi Raven on 11/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Question : NSObject {
  NSString * question;
  NSString * answer;
}
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;

@end
