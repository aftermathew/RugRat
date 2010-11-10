//
//  RRBabySettingsViewController.m
//  RugRat
//
//  Created by Mathew Chasan on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRBabySettingsViewController.h"
#import "RRLog.h"

@implementation RRBabySettingsViewController

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
    if(scrollView)
        scrollView.contentSize = CGSizeMake(320, 750);

}


// this is called when "done" or "return" is pressed on a keyboard.
// it also is called when the hidden button that fills the background of the screen is called
// and it lowers the key keyboard.
- (IBAction) doneButtonOnKeyboardPressed:(id)sender { 
    LOG_DEBUG(@"DoneButon");
    [nameField resignFirstResponder];
    [birthWeightField resignFirstResponder];
    [birthHeightField resignFirstResponder];

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


@end
