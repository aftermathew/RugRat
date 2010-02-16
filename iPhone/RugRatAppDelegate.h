//
//  RugRatAppDelegate.h
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RugRatAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UITabBarController *tabBarController;
  NSUserDefaults *userDefaults;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSUserDefaults *userDefaults;


@end

