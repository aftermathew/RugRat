//
//  RRQuestionViewController.m
//  RugRat
//
//  Created by Mathew Chasan on 6/6/10.
//  Copyright 2010 BitSyrup. All rights reserved.
//

#import "RRQuestionViewController.h"
#import "RRQAPageViewController.h"
#import "RRDatabaseInterface.h"
#import "RRLog.h"

@implementation RRQuestionViewController

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
}

-(IBAction) videosTogglePressed:(id)sender{
    LOG_INFO(@"Video's Only Pressed");
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


#pragma mark NSTableViewDataSource methods
- (NSArray*) subTopicsArray{
 return [[RRDatabaseInterface instance] questionsForAgeRange:[parent selectedAgeRange]
                                        andTopic:selectedTopic];
}

- (NSString*) subTopicName:(id) subTopic{
    RRQuestion *question = (RRQuestion*) subTopic;
    return question.questionText;
}

- (NSString*) subTopicDescription:(id) subTopic{
    //    RRQuestion *question = (RRQuestion*) subTopic;
    return @"";
}


@end
