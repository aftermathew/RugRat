//
//  RRQuestionViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRSubTopicViewController.h"
@class WebViewController;

@interface RRQuestionViewController : RRSubTopicViewController
{
    IBOutlet UIButton *showOnlyVideosButton;
    UIViewController *webViewController;
    UIWebView *webView;
}
-(IBAction) videosTogglePressed:(id)sender;
@property(nonatomic,retain)UIViewController* webViewController;
@property(nonatomic,retain)UIWebView* webView;
@end
