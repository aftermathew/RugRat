//
//  YouTubeViewController.h
//  RugRat
//
//  Created by Demi Raven on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YouTubeViewController : UIViewController {
	UIWebView * youTubeViewer;
}

@property (nonatomic, retain) IBOutlet UIWebView * youTubeViewer;

@end
