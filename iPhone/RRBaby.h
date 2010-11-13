//
//  RRBaby.h
//  RugRat
//
//  Created by Mathew Chasan on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    kSexGirl = 0,
    kSexBoy
} Sex;


@interface RRBaby : NSObject {
    NSString *name;
    Sex sex;
    NSDate * birthday;
    float birthWeight; //KG
    float birthHeight; //cm

}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate *birthday;
@property (nonatomic) float birthWeight;
@property (nonatomic) float birthHeight;
@property (nonatomic) Sex sex;

+ (RRBaby*) newBaby;
+ (NSArray*) getBabies;
+ (int) numBabies;
@end
