//
//  RRTimeRangePickerController.m
//  RugRat
//
//  Created by Mathew Chasan on 3/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRTimeRangePickerController.h"
#import "RRTimeRange.h"

@implementation RRTimeRangePickerController
@synthesize m_leftArrowButton;
@synthesize m_leftTimeButton;
@synthesize m_middleTimeButton;
@synthesize m_rightTimeButton;
@synthesize m_rightArrowButton;
@synthesize m_timeRanges;

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
	m_leftArrowButton = nil;
	m_leftTimeButton = nil;
	m_middleTimeButton = nil;
	m_rightTimeButton = nil;
	m_rightArrowButton = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void) handleButtonClick:(id)sender{
	if (sender == m_leftArrowButton) {
	}
	else if (sender == m_leftTimeButton){
		
	}
	
}

@end
