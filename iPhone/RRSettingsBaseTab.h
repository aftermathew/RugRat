//
//  RRSettingsBaseTab.h
//  RugRat
//
//  Created by Mathew Chasan on 7/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RRSettingsBaseTab : UIViewController {
    IBOutlet UIButton *accountButton;
    IBOutlet UIButton *newBabyButton;
    UIViewController *childView;
    
    NSMutableArray *babyButtons;
    NSMutableArray *babySettingsViewControllers;
}

@property (nonatomic, retain) UIViewController *childView;
-(IBAction) buttonPressed:(id)sender;

@end
