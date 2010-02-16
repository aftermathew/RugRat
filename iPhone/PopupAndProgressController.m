//
//  PopupAndProgressController.m
//  RugRat
//
//  Created by Mathew Chasan on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PopupAndProgressController.h"


@implementation PopupAndProgressController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

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
    if(progressSheet)
      [progressSheet release];
  
    [super dealloc];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"Pushed button %d", buttonIndex);
  [actionSheet release];
}

- (IBAction)popup {
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle:@"How do you feel about me?"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:@"I Love You"
                           otherButtonTitles:@"I Like You", @"Piss off", nil];
  
  [menu showFromTabBar:[[self tabBarController] tabBar]];
}

- (IBAction)progress {
  if(!progressSheet){
    progressSheet = [[UIActionSheet alloc]
                    initWithTitle:@"How much I love you... \n\n\n\n\n"
                    delegate:self
                    cancelButtonTitle:nil
                    destructiveButtonTitle:nil
                    otherButtonTitles:nil];
  
    progbar = [[UIProgressView alloc] initWithFrame:CGRectMake(50.0f, 50.0f, 220.0f, 90.0f)];
    [progressSheet addSubview:progbar];
    [progbar release];
  }

  [progbar setProgress:(progress = 0.0f)];
  [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(incrementProgress:) userInfo:nil repeats:YES];

  [progressSheet showFromTabBar:[[self tabBarController] tabBar]];
}

- (void) incrementProgress: (id) timer {
  progress += 1.0f;
  [progbar setProgress:(progress / 100.0f)];
  if (progress > 100.00) {
    [ progressSheet dismissWithClickedButtonIndex:0 animated: YES];
    [timer invalidate];
  }
}

@end
