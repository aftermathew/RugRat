//
//  RRBabySettingsViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RRBabySettingsViewController : UIViewController {
    IBOutlet UIScrollView       *scrollView;
    IBOutlet UITextField        *nameField;
    IBOutlet UISegmentedControl *girOrBoy;
    IBOutlet UIDatePicker       *birthDate;
    IBOutlet UISlider           *birthWeight;
    IBOutlet UITextField        *birthWeightField;
    IBOutlet UISlider           *birthHeight;
    IBOutlet UITextField        *birthHeightField;
}
- (IBAction) doneButtonOnKeyboardPressed:(id)sender;
@end
