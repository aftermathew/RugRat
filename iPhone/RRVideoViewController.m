//
//  RRVideoViewController.m
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RRVideoViewController.h"
#import "RRLog.h"

@implementation RRVideoViewController
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
    [super viewDidLoad];
    moviePlayerView = nil;
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
    if(moviePlayerView)
        [moviePlayerView release];
    [super viewDidUnload];
}


- (void)dealloc {
    self.logText = nil;
    [super dealloc];
}

- (IBAction)handleTextFieldClick {
}

- (IBAction)playTheFrickinMovie {	
  //NOTE: this needs to be an mp4/m4v - the following line will not work
    if(movieUrl == nil)
        return;
 
    if(moviePlayerView == nil){
        moviePlayerView = [[[MPMoviePlayerViewController alloc] initWithContentURL:movieUrl] retain];
    }
    else {
        [moviePlayerView.moviePlayer stop]; // reset the play head to 0.00
    }
    [self presentMoviePlayerViewControllerAnimated:moviePlayerView];
   
    LOG_DEBUG(@"playin the movie");
}

- (void) logNotification:(NSNotification *)notification {
    LOG_DEBUG(@"gettin notifys");
    LOG_INFO(@"%@", [notification description]);
    logText.text = [NSString stringWithFormat: @"%@%@: %@\n", logText.text, [NSDate date], [notification description]];
}

+ (NSURL*) localMovie{
  NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"cavity_flow_movie" ofType:@"mp4"];
  if (videoPath == nil) 
  {
      LOG_WARN(@"issue with video path");
      return nil;
  }
    LOG_INFO(@"Initializing move player with path:%@", videoPath);  
  return [NSURL fileURLWithPath:videoPath];
}

+ (NSURL*) onlineMovie{
  return [NSURL URLWithString:@"http://artastic.us/cavity_flow_movie.mp4"];
}

@end
