//
//  RRQuestionViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRDatabaseInterface.h"
@class RRTopicPageViewController;

@interface RRQuestionViewController : UIViewController <UITableViewDataSource,
                                                        UITableViewDelegate>
{
    IBOutlet UIButton *showOnlyVideosButton;
    IBOutlet UITableView *questionTable;
    RRTopicPageViewController* parent;
    RRTopic* selectedTopic;
}

@property (nonatomic, retain) RRTopicPageViewController *parent;
-(void) setTopic:(RRTopic*) topic;
-(IBAction) videosTogglePressed:(id)sender;
@end
