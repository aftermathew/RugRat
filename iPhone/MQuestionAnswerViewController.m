//
//  MQuestionAnswerViewController.m
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MQuestionAnswerViewController.h"
#import "Topic.h"
#include <sqlite3.h>

@implementation MQuestionAnswerViewController
@synthesize topics;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

- (void)openQuestionsDB {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"sqlite"];
  //NSLog(@"%@", path);
  dbrc = sqlite3_open([path UTF8String], &db);
  if (dbrc == SQLITE_OK) {
    NSLog(@"Database Successfully Opened :) ");
  } else {
    NSLog(@"Error in opening database :( ");
    db = nil;
  }
}

- (void)getDataFromQuestionsDB {
  if (nil != db) 
  {
    NSMutableArray * allTopics = [[NSMutableArray alloc] init];
    const char * myselect = "select * from topics";
    dbrc = sqlite3_prepare_v2 (db, myselect, -1, &statement, NULL);
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
      char * ctopicname = (char *)sqlite3_column_text(statement, 1);
      int itopicid = (int)sqlite3_column_int(statement, 0);
      NSString * topicname = [NSString stringWithFormat:@"%s", ctopicname];
      [allTopics addObject:[[Topic alloc] initWithName:topicname withID:itopicid]];
    }
    sqlite3_finalize(statement);
    self.topics = allTopics;
    [allTopics release];
    NSLog(@"db read, %i topics.", [self.topics count]);
  }
}

- (void)closeQuestionsDB {
  if (nil != db) 
  {
    dbrc = sqlite3_close(db);
    if (dbrc == SQLITE_OK)
    {
      NSLog(@"Database closed.");
      db = nil;
    }
    else 
    {
      NSLog(@"Database closing failure. %i", dbrc);
    } 
  }
}

- (void)viewWillAppear:(BOOL)animated {
  if (nil == topics)
  {
    [self openQuestionsDB];
    [self getDataFromQuestionsDB];
    [self closeQuestionsDB];
  }
  [super viewWillAppear:animated];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topics count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
  Topic * cellTopic = [self.topics objectAtIndex:indexPath.row];
  NSString * cellText = [cellTopic topicName]; 
  NSLog(@"%@ of %i items, topic name is %@", cellText, [self.topics count], cellText);
  cell.textLabel.text = cellText;
    return cell;
}

//delegate method - can override display here if necessary, such as setting a backgroundView...
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"displaying cell");
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
  self.topics = nil;
  [super dealloc];
}


@end

