//
//  MVideoViewController.m
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MVideoViewController.h"

@implementation MVideoViewController
@synthesize logText;
@synthesize movieUrl;

/*
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
// Custom initialization
}
return self;
}
*/

- (void)viewWillAppear:(BOOL)animated
{
  [logText setBackgroundColor:[UIColor whiteColor]];
  UIFont * currentFont = [logText font];
  [logText setFont:[currentFont fontWithSize:10.0f]];
  //logText.scrollEnabled = YES;
  [super viewWillAppear:animated];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logNotification:) name:@"MPMoviePlayerContentPreloadDidFinishNotification" object:nil]; 
  [super viewDidLoad];
}


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
  [m_moviePlayer release];
  self.logText = nil;
  [super dealloc];
}

- (IBAction)handleTextFieldClick {
}

- (IBAction)playTheFrickinMovie {	
  //NOTE: this needs to be an mp4/m4v - the following line will not work
	if(movieUrl == nil)
    return;
  
  m_moviePlayer = [[[MPMoviePlayerController alloc] initWithContentURL:movieUrl] retain];
  [m_moviePlayer play];
  NSLog(@"playin the movie");
}

- (void) logNotification:(NSNotification *)notification {
  NSLog(@"gettin notifys");
  NSLog(@"%@", [notification description]);
  logText.text = [NSString stringWithFormat: @"%@%@: %@\n", logText.text, [NSDate date], [notification description]];
}

+ (NSURL*) localMovie{
  NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"cavity_flow_movie" ofType:@"mp4"];
  if (videoPath == nil) 
  {
    NSLog(@"issue with video path");
    return nil;
  }
  return [NSURL fileURLWithPath:videoPath];
}

+ (NSURL*) onlineMovie{
  return [NSURL URLWithString:@"http://artastic.us/cavity_flow_movie.mp4"];
}

@end
