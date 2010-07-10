//
//  RRTopicPageViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRDatabaseInterface.h"



@class RRSubTopicViewController;

@interface RRTopicPageViewController :
    UIViewController <UITableViewDataSource,
                      UITableViewDelegate> {

    IBOutlet UIButton *leftArrowButton;
    IBOutlet UIButton *rightArrowButton;
    IBOutlet UISegmentedControl *segmentedControl;

    IBOutlet UITableView *subTopicTable;

    RRSubTopicViewController *subTopicViewController;
    RRTopic *selectedTopic;
}

@property (nonatomic, retain) RRSubTopicViewController *subTopicViewController;
@property (nonatomic, retain) RRTopic *selectedTopic;

-(NSInteger) selectedAgeRangeIndex;
-(RRTimeRange*) selectedAgeRange;

-(IBAction) segmentedControlPressed:(id)sender;
-(IBAction) buttonPressed:(id)sender;

// This function should be overwritten appropriately by child class.
// default implemenation returns an empty list.
-(NSArray*) topicsArrayForSelectedAgeRange;

@end
