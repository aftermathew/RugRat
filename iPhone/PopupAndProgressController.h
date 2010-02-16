//
//  PopupAndProgressController.h
//  RugRat
//
//  Created by Mathew Chasan on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PopupAndProgressController : UIViewController <UIActionSheetDelegate> {
  float progress;
  UIActionSheet *progressSheet;
  UIProgressView *progbar;
}

- (IBAction) popup;
- (IBAction) progress;
- (void) incrementProgress: (id) timer;

@end
