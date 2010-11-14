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
#import "RRBabySettingsViewController.h"
#import "RRBaby.h"

@interface BabyButton : NSObject {
    RRBaby   *baby;
    UIButton *button;
}
@property (nonatomic, retain) RRBaby* baby;
@property (nonatomic, retain) UIButton* button;

+ (BabyButton*) babyButtonFromButton: (UIButton*)new_button;
- (BabyButton*) initFromButton:(UIButton*)new_button;

@end;

@implementation BabyButton
@synthesize baby;
@synthesize button;

- (BabyButton*) initFromButton:(UIButton*)new_button{
    if(self = [super init]) {
        self.baby = [RRBaby newBaby];

        // you can't call copy on a button but this works pretty well.
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject: new_button];
        self.button = [NSKeyedUnarchiver unarchiveObjectWithData: archivedData];
    }

    return self;
}

+ (BabyButton*) babyButtonFromButton:(UIButton*) new_button {
    return [[[BabyButton alloc] initFromButton: new_button] autorelease];
}

@end


@implementation RRSettingsBaseTab
@synthesize childView;
@synthesize babyButtons;




-(void) drawBabyButtons{
    const int buttonHeightDiff = 60;

    [newBabyButton removeFromSuperview];

    NSEnumerator *enumerator = [babyButtons objectEnumerator];
    CGRect newFrame = [accountButton frame];
    BabyButton * curItem;

    while (curItem = (BabyButton*)[enumerator nextObject]) {
        UIButton *curButton = curItem.button;
        RRBaby *baby = curItem.baby;

        newFrame.origin.y += buttonHeightDiff;
        curButton.frame = newFrame;

        NSString* name = baby.name;
        if(name == nil || name == @"")
            name = @"OMG Baby!";

        [curButton setTitle:name forState:UIControlStateNormal];
        [curButton setTitle:name forState:UIControlStateSelected];


        UIImage* baseImage;
        if(baby.sex == kSexBoy)
            baseImage = [UIImage imageNamed:@"blueButton.png"];
        else
            baseImage = [UIImage imageNamed:@"pinkButton.png"];

        UIImage *buttonImage = [baseImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [curButton setBackgroundImage:buttonImage forState:UIControlStateNormal];

        [self.view addSubview:curButton];
    }

    newFrame.origin.y += buttonHeightDiff * 1.5;
    newBabyButton.frame = newFrame;
    [self.view addSubview:newBabyButton];
}

-(void) loadBabySettingsViewControllerForBaby: (RRBaby*) baby {
        RRBabySettingsViewController *child = [[RRBabySettingsViewController alloc] init];
        child.baby = baby;
        child.parentView = self;

        self.childView = nil;
        self.childView = child;
        [self.navigationController pushViewController:childView animated:YES];

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

    else if (sender == newBabyButton) {
        BabyButton * newBabyButtonObject  = [BabyButton babyButtonFromButton:newBabyButton];
        [babyButtons addObject:newBabyButtonObject];

        UIButton * newButton = newBabyButtonObject.button;
        [newButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        self.drawBabyButtons;
        newBabyButtonObject.baby.name = @"";
        [self loadBabySettingsViewControllerForBaby: newBabyButtonObject.baby];
    }

    else {
        LOG_DEBUG(@"BABY BUTTON");
        // find the sender in buttons array..
        NSEnumerator *enumerator = [babyButtons objectEnumerator];
        BabyButton *curButton;
        while (curButton = (BabyButton*)[enumerator nextObject]) {
            if(sender == curButton.button)
                break;
        }

        [self loadBabySettingsViewControllerForBaby:curButton.baby];
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
    