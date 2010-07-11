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
@synthesize webViewController;
@synthesize webView;
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
    webViewController = nil;
    webView = nil;
        
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

- (void) setWebViewUrlToIndex:(NSInteger) index{

}

- (void)subTopicSelected:(NSInteger)topicIndex{
    [self setWebViewUrlToIndex:topicIndex];

    if(webViewController == nil){
        webViewController = [[UIViewController alloc] init];
        webView = [[UIWebView alloc] initWithFrame: CGRectMake(0,0,320,480)];
        [webViewController.view addSubview: webView];
        [webView release];
	}
        
    NSString *search = [[self subTopicName:[[self subTopicsArray] objectAtIndex:topicIndex]]
                            stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    search = [@"search?q=" stringByAppendingString:search];
    NSURL * url = [[NSURL alloc] initWithString:[@"http://www.google.com/" stringByAppendingString:search]];
	NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];    
    [url release];
    [request release];

    [self.navigationController pushViewController:webViewController animated:YES];
}
@end
