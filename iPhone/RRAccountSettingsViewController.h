//
//  RRAccountSettingsViewController.h
//  RugRat
//
//  Created by Mathew Chasan on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RRAccountSettingsViewController : UIViewController {
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *usernameField;
    
    IBOutlet UITextField *oldPasswordField;
    IBOutlet UITextField *newPasswordField;
    IBOutlet UITextField *confirmNewPasswordField;
    IBOutlet UIButton *changePasswordButton;
    
    IBOutlet UISegmentedControl *imperialOrMetric;
 

}


@end
