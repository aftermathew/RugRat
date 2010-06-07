//
//  RRQuestionViewController.m
//  RugRat
//
//  Created by Mathew Chasan on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRQuestionViewController.h"
#import "RRQAPageViewController.h"
#import "RRDatabaseInterface.h"
#import "RRLog.h"

@implementation RRQuestionViewController

@synthesize parent;
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
    selectedTopic = nil;
}

-(void) setTopic:(RRTopic*) topic{
    if(selectedTopic)
        [selectedTopic release];
    
    selectedTopic = [topic retain];
    self.title = topic.topicText;
    [questionTable reloadData];
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
- (NSMutableArray*) questionsArray{
 return [[RRDatabaseInterface instance] questionsForAgeRange:[parent selectedAgeRange]
                                                    andTopic:selectedTopic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // this class is only supplying the data to one table
    // and that table has only one section, so ignore
    // both arguments and just return the count of the data.
     return [self questionsArray].count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 	static NSString *CellIdentifier = @"Cell"; 
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle// UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
	}
    
	RRQuestion  *question= [[self questionsArray] objectAtIndex:indexPath.row];
	cell.textLabel.text = question.questionText;
	cell.detailTextLabel.text = @"";
    return cell;
}


@end
