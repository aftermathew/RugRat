//
//  RRQuestionViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRSubTopicViewController.h"
@class RRTopicPageViewController;

@interface RRQuestionViewController : RRSubTopicViewController
{
    IBOutlet UIButton *showOnlyVideosButton;
}
-(IBAction) videosTogglePressed:(id)sender;
@end
