/* RRSubTopicViewController.h

   written by Mathew Chasan
   10 Jul 2010

   Copyright (C) 2010 Bitsyrup

   -----------
   DESCRIPTION
   -----------

*/

#import "RRTopicPageViewController.h"

@interface RRSubTopicViewController : UIViewController <UITableViewDataSource,
                                                        UITableViewDelegate>
{
    IBOutlet UITableView *subTopicTable;
    RRTopicPageViewController* parent;
    RRTopic* selectedTopic;
}

@property (nonatomic, retain) RRTopicPageViewController *parent;
-(void) setTopic:(RRTopic*) topic;

// Should be filled out by child classes
// default implementation returns an empty array here.
-(NSArray*) subTopicsArray;
// default implementation does nothing
- (void)subTopicSelected:(NSInteger)topicIndex;
@end
