//
//  RRAccountSettingsViewController.m
//  RugRat
//
//  Created by Mathew Chasan on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRAccountSettingsViewController.h"
#import "RRLog.h"


@implementation RRAccountSettingsViewController


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        
         
    }
    return self;
}
*/


// this is called when "done" or "return" is pressed on a keyboard.
// it also is called when the hidden button that fills the background of the screen is called
// and it lowers the key keyboard.
- (IBAction) doneButtonOnKeyboardPressed:(id)sender { 
    LOG_DEBUG(@"DoneButon");
    [emailField resignFirstResponder];
    [usernameField resignFirstResponder];
    [oldPasswordField resignFirstResponder];
    [newPasswordField resignFirstResponder];
    [confirmNewPasswordField resignFirstResponder];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if(scrollView)
        scrollView.contentSize = CGSizeMake(320, 500);
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
