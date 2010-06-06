//
//  RRQAPageViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRDatabaseInterface.h"

@interface RRQAPageViewController :
    UIViewController <UIPickerViewDelegate,
                      UIPickerViewDataSource,
                      UITableViewDataSource,
                      UITableViewDelegate> {
                          
    IBOutlet UIButton *leftArrowButton;
    IBOutlet UIButton *rightArrowButton;
    IBOutlet UISegmentedControl *segmentedControl;
    
    IBOutlet UITableView *questionTable;
    IBOutlet UIPickerView *ageRangePicker;

    
    NSArray * ageRanges;
    NSInteger leftMostAgeRangeIndex;
}

-(NSInteger) selectedAgeRangeIndex;
-(IBAction) segmentedControlPressed:(id)sender;
-(IBAction) buttonPressed:(id)sender;
@end

