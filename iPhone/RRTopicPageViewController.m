//
//  RRTopicPageController.m
//  RugRat
//
//  Created by Mathew Chasan on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRTopicPageViewController.h"
#import "RRQuestionViewController.h"

#import "RRLog.h"

@implementation RRTopicPageViewController
@synthesize questionViewController;
@synthesize selectedTopic;

NSArray * ageRanges;
NSInteger leftMostAgeRangeIndex;
Boolean ignoreSegmentedChange = NO;

#pragma mark Local Utility Functions
-(NSInteger) selectedAgeRangeIndex{
    return leftMostAgeRangeIndex + segmentedControl.selectedSegmentIndex;
}

-(RRTimeRange*) selectedAgeRange{
    return (RRTimeRange*) [ageRanges objectAtIndex:[self selectedAgeRangeIndex]];
}

#pragma mark AgeRangeUI Methods
-(void) updateLeftMostAgeRangeIndex: (NSInteger) newIndex{
    if(newIndex < 0 || newIndex > [ageRanges count] - 3){
        LOG_ERROR(@"Attempted to set age range to illegal index of %d", newIndex);
        return;
    }

    NSInteger selected = segmentedControl.selectedSegmentIndex;
    ignoreSegmentedChange = YES;
    segmentedControl.selectedSegmentIndex = -1;

    leftArrowButton.enabled = YES;
    rightArrowButton.enabled = YES;

    if(newIndex == 0){
        leftArrowButton.enabled = NO;
    }
    if(newIndex == [ageRanges count] - 3){
        rightArrowButton.enabled = NO;
    }


    // left button was pushed
    if(leftMostAgeRangeIndex > newIndex){
        [segmentedControl removeSegmentAtIndex:segmentedControl.numberOfSegments - 1 animated: NO];
        [segmentedControl insertSegmentWithTitle:((RRTimeRange*) [ageRanges objectAtIndex:newIndex]).name atIndex:0 animated:YES];

        if(selected < segmentedControl.numberOfSegments - 1)
            selected += 1;
    }
    // right button was pushed
    else{
        [segmentedControl removeSegmentAtIndex:0 animated: NO];
        [segmentedControl insertSegmentWithTitle:((RRTimeRange*) [ageRanges objectAtIndex:newIndex + segmentedControl.numberOfSegments]).name
                                         atIndex:segmentedControl.numberOfSegments animated:YES];

        if(selected > 0)
            selected -= 1;
    }

    leftMostAgeRangeIndex = newIndex;
    ignoreSegmentedChange = NO;

    segmentedControl.selectedSegmentIndex = selected;

}


-(IBAction) segmentedControlPressed:(id)sender{
    if(!ignoreSegmentedChange){
        [questionTable reloadData];
    }
}

-(IBAction) buttonPressed:(id)sender{

    if (sender == leftArrowButton) {
        LOG_INFO(@"leftArrow");
        if(leftMostAgeRangeIndex > 0){
            [self updateLeftMostAgeRangeIndex:leftMostAgeRangeIndex - 1];
        }
    }
    else if (sender == rightArrowButton){
        LOG_INFO(@"rightArrow");
        if(leftMostAgeRangeIndex < ([ageRanges count] - [segmentedControl numberOfSegments]))
            [self updateLeftMostAgeRangeIndex:leftMostAgeRangeIndex + 1];
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
    self.title = @"Topics";
    questionViewController.parent = self;

    UIImage *leftImage  = [UIImage imageNamed:@"leftArrowIcon.png"];
    UIImage *rightImage = [UIImage imageNamed:@"rightArrowIcon.png"];

    leftArrowButton.enabled = NO;
    [leftArrowButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [rightArrowButton setBackgroundImage:rightImage forState:UIControlStateNormal];

    ageRanges = [[[RRDatabaseInterface instance] ageRanges] retain];
    leftMostAgeRangeIndex = 0;

    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl removeAllSegments];
    for(int i = 0; i < 3 && i < ageRanges.count; i++){
        [segmentedControl insertSegmentWithTitle:((RRTimeRange*) [ageRanges objectAtIndex:i]).name
                                         atIndex:i
                                        animated: NO];

    }

    segmentedControl.selectedSegmentIndex = 0;

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
    [ageRanges release];
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark UITableViewDataSource methods
- (NSMutableArray*) topicsArrayForSelectedAgeRange{
    RRTimeRange *selectedTimeRange = [self selectedAgeRange];
    return [[RRDatabaseInterface instance] topicsForAgeRange:selectedTimeRange];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // this class is only supplying the data to one table
    // and that table has only one section, so ignore
    // both arguments and just return the count of the data.
     return [self topicsArrayForSelectedAgeRange].count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle// UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
	}

	RRTopic *topic= [[self topicsArrayForSelectedAgeRange] objectAtIndex:indexPath.row];
	cell.textLabel.text = topic.topicText;
	cell.detailTextLabel.text = topic.description;
    return cell;
}

#pragma mark UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedTopic = [[self topicsArrayForSelectedAgeRange] objectAtIndex:indexPath.row];
    [questionViewController setTopic:selectedTopic];

    [self.navigationController pushViewController:self.questionViewController
                                         animated:YES];
}

@end
