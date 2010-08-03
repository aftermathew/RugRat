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
@synthesize babyButtons;



-(void) drawBabyButtons{
    const int buttonHeightDiff = 60;

    [newBabyButton removeFromSuperview];
    
    NSEnumerator *enumerator = [babyButtons objectEnumerator];
    UIButton *curButton;
    CGRect newFrame = [accountButton frame];
    while (curButton = (UIButton*)[enumerator nextObject]) {
        newFrame.origin.y += buttonHeightDiff;
        curButton.frame = newFrame;
        [self.view addSubview:curButton];
    }    
    
    newFrame.origin.y += buttonHeightDiff;
    newBabyButton.frame = newFrame;
    [self.view addSubview:newBabyButton];
}


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

        // you can't call copy on a button but this works pretty well.
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject: newBabyButton];
        UIButton *newButton = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];

        [newButton setTitle:@"Just Born" forState:UIControlStateNormal];
        [newButton setTitle:@"Just Born" forState:UIControlStateSelected];
        
        [babyButtons addObject:newButton];
        self.drawBabyButtons;
    }
    
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.drawBabyButtons;
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    childView = nil;
    if(!babyButtons)
        babyButtons = [[NSMutableArray alloc] init];
    
    LOG_DEBUG(@"%@");

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
    babyButtons = nil;
}



@end
