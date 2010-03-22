//
//  RRTimeRangePickerController.h
//  RugRat
//
//  Created by Mathew Chasan on 3/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRTimeRangePickerController : UIViewController {
	UIButton* m_leftArrowButton;
	UIButton* m_rightArrowButton;
	UIButton* m_leftTimeButton;
	UIButton* m_middleTimeButton;
	UIButton* m_rightTimeButton;

	NSMutableArray * m_timeRanges;	
}

@property (retain, nonatomic) IBOutlet UIButton * m_leftArrowButton;
@property (retain, nonatomic) IBOutlet UIButton * m_rightArrowButton;
@property (retain, nonatomic) IBOutlet UIButton * m_leftTimeButton;
@property (retain, nonatomic) IBOutlet UIButton * m_middleTimeButton;
@property (retain, nonatomic) IBOutlet UIButton * m_rightTimeButton;

@property (nonatomic, retain) NSMutableArray * m_timeRanges;

- (IBAction) handleButtonClick:(id)sender;

@end
