//
//  RRQAPageController.m
//  RugRat
//
//  Created by Mathew Chasan on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RRQAPageViewController.h"
#import "RRLog.h"

@implementation RRQAPageViewController
Boolean ignoreSegmentedChange = NO;


-(NSInteger) selectedAgeRangeIndex{
    return leftMostAgeRangeIndex + segmentedControl.selectedSegmentIndex;
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
        [segmentedControl removeSegmentAtIndex:segmentedControl.numberOfSegments - 1 animated: YES];
        [segmentedControl insertSegmentWithTitle:((RRTimeRange*) [ageRanges objectAtIndex:newIndex]).name atIndex:0 animated:YES];            
        
        if(selected < segmentedControl.numberOfSegments - 1)
            selected += 1;
    }
    // right button was pushed
    else{
        [segmentedControl removeSegmentAtIndex:0 animated: YES];
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
        LOG_INFO(@"TEST");
        [ageRangePicker selectRow:segmentedControl.selectedSegmentIndex + leftMostAgeRangeIndex
                      inComponent:0
                         animated:YES];
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
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"leftArrowIcon" ofType:@".png"];
    UIImage *leftImage  = [UIImage imageNamed:@"leftArrowIcon.png"];
    UIImage *rightImage = [UIImage imageNamed:@"rightArrowIcon.png"];
        
    leftArrowButton.enabled = NO;
    [leftArrowButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [rightArrowButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    
    ageRanges = [[[RRDatabaseInterface instance] ageRanges] retain];
    leftMostAgeRangeIndex = 0;
//    [self updateSelectedAgeRangeIndex: 0];
    
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


#pragma mark UIPickerViewDataSource methods 
-(NSInteger) pickerView: (UIPickerView*) pickerView numberOfRowsInComponent: (NSInteger) component { 
    return [ageRanges count];
} 

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


#pragma mark UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
    RRTimeRange *timerange = (RRTimeRange *) [ageRanges objectAtIndex:row];
    return timerange.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
    LOG_INFO(@"Component at row %d picked, it was named %@",
             row,
             ((RRTimeRange*) [ageRanges objectAtIndex:row]).name);
}



@end
