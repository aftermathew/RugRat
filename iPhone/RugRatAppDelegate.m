//
//  RugRatAppDelegate.m
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright BitSyrup 2009. All rights reserved.
//

#import "RugRatAppDelegate.h"
#import "MVideoViewController.h"

@implementation RugRatAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize userDefaults;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

  // Override point for customization after application launch
  [window addSubview:[tabBarController view]];
  [window makeKeyAndVisible];

  
  // do setup on view controllers
  // iterate through view controllers looking for movie player controllers
  // setup their urls
  NSArray *viewControllers = [tabBarController viewControllers];
  NSEnumerator *enumerator = [viewControllers objectEnumerator];
  id aView;
  while (aView = [enumerator nextObject]) {
    if([aView isMemberOfClass:[MVideoViewController class]]){
      MVideoViewController *vidController = (MVideoViewController*)aView;
      if([[[vidController tabBarItem] title] compare:@"Online Video"] == NSOrderedSame)
        [vidController setMovieUrl:[MVideoViewController onlineMovie]];
      else
        [vidController setMovieUrl:[MVideoViewController localMovie]];
    }
  }
  
  
  //setup the application preferences and user defaults
  userDefaults = [NSUserDefaults standardUserDefaults];
  if([userDefaults objectForKey:@"LastTab"]){
    NSInteger tabNum = [userDefaults integerForKey:@"LastTab"];
    tabBarController.selectedIndex = tabNum;
    [self.tabBarController.selectedViewController viewDidAppear:YES];
  }
  
}


- (void)dealloc {
  self.tabBarController = nil;
  [window release];
  [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // save user data to NSDefaults
  NSLog(@"We are terminating");
  [userDefaults setInteger:[tabBarController selectedIndex] forKey:@"LastTab"];
}

@end
