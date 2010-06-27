//
//  RRQuestionViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRDatabaseInterface.h"
@class RRQAPageViewController;

@interface RRQuestionViewController : UIViewController <UITableViewDataSource,
                                                        UITableViewDelegate>
{
    IBOutlet UIButton *showOnlyVideosButton;
    IBOutlet UITableView *questionTable;
    RRQAPageViewController* parent;
    RRTopic* selectedTopic;
}

@property (nonatomic, retain) RRQAPageViewController *parent;
-(void) setTopic:(RRTopic*) topic;
-(IBAction) videosTogglePressed:(id)sender;
@end
