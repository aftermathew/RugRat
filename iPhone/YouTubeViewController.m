//
//  YouTubeViewController.m
//  RugRat
//
//  Created by Demi Raven on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YouTubeViewController.h"


@implementation YouTubeViewController
@synthesize youTubeViewer;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewWillAppear:(BOOL)animated{
	////NOTE: a snippet like below will embed the YouTube player in the UIWebView
	////NOTE: requires a youtube api dev key 
	////NOTE: Mothering app dev key is below...
    
	//NSString * devkey = @"AI39si5dP3f6O-lVExQdhLiPopB4tYGFk8aznzU-b5fwHejCYEdn3IFMbTAVsECkzUyJaQj2BHnrHcmoOuBNr0vSpx9J63wtGw";	
	//NSString *htmlString = @"<html><head>" +
	//"<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head>" +
	//"<body style=\"background:#F00;margin-top:0px;margin-left:0px\">" +
	//"<div><object width=\"212\" height=\"172\">" +
	//"<param name=\"movie\" value=\"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&d=AI39si5dP3f6O-lVExQdhLiPopB4tYGFk8aznzU-b5fwHejCYEdn3IFMbTAVsECkzUyJaQj2BHnrHcmoOuBNr0vSpx9J63wtGw\"></param>" +
	//"<param name=\"wmode\" value=\"transparent\"></param>" +
	//"<embed src=\"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&d=AI39si5dP3f6O-lVExQdhLiPopB4tYGFk8aznzU-b5fwHejCYEdn3IFMbTAVsECkzUyJaQj2BHnrHcmoOuBNr0vSpx9J63wtGw\"" +
	//"type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"212\" height=\"172\"></embed>" +
	//"</object></div></body></html>";
	//[webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.your-url.com"]];
	
	NSURL * url = [[NSURL alloc] initWithString:@"http://www.google.com"];
	NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
	[youTubeViewer loadRequest:request];
	[request release];
	[url release];
	[super viewWillAppear:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.youTubeViewer = nil;
    [super dealloc];
}


@end
