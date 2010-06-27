//
//  RRTopicPageViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRDatabaseInterface.h"



@class RRQuestionViewController;

@interface RRTopicPageViewController :
    UIViewController <UITableViewDataSource,
                      UITableViewDelegate> {

    IBOutlet UIButton *leftArrowButton;
    IBOutlet UIButton *rightArrowButton;
    IBOutlet UISegmentedControl *segmentedControl;

    IBOutlet UITableView *questionTable;

    RRQuestionViewController *questionViewController;
    RRTopic *selectedTopic;
}

@property (nonatomic, retain) IBOutlet RRQuestionViewController *questionViewController;
@property (nonatomic, retain) RRTopic *selectedTopic;

-(NSInteger) selectedAgeRangeIndex;
-(RRTimeRange*) selectedAgeRange;

-(IBAction) segmentedControlPressed:(id)sender;
-(IBAction) buttonPressed:(id)sender;
@end
