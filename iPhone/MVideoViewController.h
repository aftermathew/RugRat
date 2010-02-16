//
//  MVideoViewController.h
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MVideoViewController : UIViewController <UITextFieldDelegate> {
  UITextView * logText;
  MPMoviePlayerController *m_moviePlayer;
  NSURL *movieUrl;
}

@property (retain, nonatomic) IBOutlet UITextView * logText;
@property (retain, nonatomic) NSURL *movieUrl;

- (IBAction) handleTextFieldClick;
- (IBAction) playTheFrickinMovie;

// HACK 
// MATHEW
// these two functions just to prove out the concept of online and local movies.
// they should not exist in the real program
+ (NSURL *) localMovie;
+ (NSURL *) onlineMovie;

@end
