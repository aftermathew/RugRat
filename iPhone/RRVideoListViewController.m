//
//  RRVideoListViewController.m
//  RugRat
//
//  Created by Mathew Chasan on 7/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRVideoListViewController.h"
#import "RRLog.h"

@implementation RRVideoListViewController
@synthesize moviePlayerView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    moviePlayerView = nil;
}

#pragma mark NSTableViewDataSource methods
- (NSArray*) subTopicsArray{
    return [[RRDatabaseInterface instance] videosForAgeRange:[parent selectedAgeRange]
                                                    andTopic:selectedTopic];
}

- (NSString*) subTopicName:(id) subTopic{
    RRMedia *video = (RRMedia*) subTopic;
    return [video.description stringByAppendingFormat:@" about %@", parent.selectedTopic.topicText];
}

- (NSString*) subTopicDescription:(id) subTopic{
//    RRMedia *video = (RRMedia*) subTopic;
    // Don't bother seeding rand as these are just faked times anyway.
    return [NSString stringWithFormat:@"%d:%02d %@",
                random()%7,
                random()%60,
            (random()%4 > 2) ? @"Already Viewed" : @""];
}


- (void)subTopicSelected:(NSInteger)topicIndex{
    
    NSString* urlString = ((RRMedia*)[self.subTopicsArray objectAtIndex:topicIndex]).mediaPath;
    
    moviePlayerView =   [[[MPMoviePlayerViewController alloc]
                         initWithContentURL:[NSURL URLWithString:urlString]] autorelease];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerView];
    
    LOG_DEBUG(@"playin the movie");
}


@end
