//
//  RRSettingsBaseTab.m
//  RugRat
//
//  Created by Mathew Chasan on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRSettingsBaseTab.h"
#import "RRLog.h"
#import "RRAccountSettingsViewController.h"

@implementation RRSettingsBaseTab
@synthesize childView;

-(IBAction) buttonPressed:(id)sender{
    if (sender == accountButton) {
        LOG_DEBUG(@"Account Button");
        childView = nil;
        childView = [[RRAccountSettingsViewController alloc] init];
        LOG_DEBUG(@"nav: %@", self.navigationController);

        [self.navigationController pushViewController:self.childView
                                             animated:YES];
    }
    
    if (sender == newBabyButton) {
        LOG_DEBUG(@"OMG... NEWBABY!");
    }
    
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    childView = nil;
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
    childView = nil;
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    childView = nil;
}


- (void)dealloc {
    [super dealloc];
}



@end
