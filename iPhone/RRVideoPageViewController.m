    //
//  RRVideoPageViewController.m
//  RugRat
//
//  Created by Mathew Chasan on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRVideoPageViewController.h"
#import "RRVideoListViewController.h"

@implementation RRVideoPageViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    if(subTopicViewController == nil)
        subTopicViewController = [[[RRVideoListViewController alloc] init] retain];
    [super loadView];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Videos";
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


- (NSArray*) topicsArrayForSelectedAgeRange{
    RRTimeRange *selectedTimeRange = [self selectedAgeRange];
    return [[RRDatabaseInterface instance] videoTopicsForAgeRange:selectedTimeRange];
}

@end
