//
//  RRSubTopicViewController.m
//  RugRat
//
//  Created by Mathew Chasan on 7/10/10.
//  Copyright 2010 Bitsyrup. All rights reserved.
//

#import "RRSubTopicViewController.h"
#import "RRQAPageViewController.h"
#import "RRDatabaseInterface.h"
#import "RRLog.h"

@implementation RRSubTopicViewController

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
    [subTopicTable reloadData];
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
    return [[[NSArray init] alloc] autorelease];
}

- (NSString*) subTopicName:(id) subTopic {
    return @"";
}

- (NSString*) subTopicDescription:(id) subTopic {
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // this class is only supplying the data to one table
    // and that table has only one section, so ignore
    // both arguments and just return the count of the data.
    return [self subTopicsArray].count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle// UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
	}

	id subTopic = [[self subTopicsArray] objectAtIndex:indexPath.row];
	cell.textLabel.text = [self subTopicName:subTopic];
	cell.detailTextLabel.text = [self subTopicDescription:subTopic];
    return cell;
}


@end
