//
//  RRQAPageViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRDatabaseInterface.h"

@class RRQuestionViewController;

@interface RRQAPageViewController :
    UIViewController <UITableViewDataSource,
                      UITableViewDelegate> {
                          
    IBOutlet UIButton *leftArrowButton;
    IBOutlet UIButton *rightArrowButton;
    IBOutlet UISegmentedControl *segmentedControl;
    
    IBOutlet UITableView *questionTable;

    RRQuestionViewController *questionViewController;
    NSArray * ageRanges;
    NSInteger leftMostAgeRangeIndex;
}

@property (nonatomic, retain) IBOutlet RRQuestionViewController *questionViewController;

-(NSInteger) selectedAgeRangeIndex;
-(IBAction) segmentedControlPressed:(id)sender;
-(IBAction) buttonPressed:(id)sender;
@end

