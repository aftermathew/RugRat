//
//  RRTimeRangePickerController.h
//  RugRat
//
//  Created by Mathew Chasan on 3/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RRTimeRangePicker  : UIView
{
    IBOutlet UIButton* m_leftArrowButton;
    IBOutlet UIButton* m_rightArrowButton;
    IBOutlet UIButton* m_leftTimeButton;
    IBOutlet UIButton* m_middleTimeButton;
    IBOutlet UIButton* m_rightTimeButton;
}

- (IBAction) handleButtonClick:(id)sender;


@end



@interface RRTimeRangePickerController : UIViewController {

    NSMutableArray * m_timeRanges;
}


@property (nonatomic, retain) NSMutableArray * m_timeRanges;


@end
