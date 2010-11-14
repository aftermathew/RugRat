//
//  RRBabySettingsViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 8/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRBaby.h"
#import "RRSettingsBaseTab.h"

@interface RRBabySettingsViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UIScrollView       *scrollView;
    IBOutlet UITextField        *nameField;
    IBOutlet UISegmentedControl *girlOrBoy;
    IBOutlet UIDatePicker       *birthDate;
    IBOutlet UISlider           *birthWeight;
    IBOutlet UITextField        *birthWeightField;
    IBOutlet UISlider           *birthHeight;
    IBOutlet UITextField        *birthHeightField;
    RRBaby                      *baby;
    RRSettingsBaseTab           *parentView;
}
- (IBAction) doneButtonOnKeyboardPressed:(id)sender;
- (void) textFieldDidEndEditing:(UITextField*)textField;

@property (nonatomic, retain) RRBaby* baby;
@property (nonatomic, retain) RRSettingsBaseTab* parentView;
@end
