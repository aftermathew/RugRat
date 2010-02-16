//
//  RugRatAppDelegate.m
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright BitSyrup 2009. All rights reserved.
//

#import "RugRatAppDelegate.h"
#import "RRVideoViewController.h"

static NSString *const lastTabUserDefaultString = @"LastTab";

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
    if([aView isMemberOfClass:[RRVideoViewController class]]){
      RRVideoViewController *vidController = (RRVideoViewController*)aView;
      if([[[vidController tabBarItem] title] compare:@"Online Video"] == NSOrderedSame)
        [vidController setMovieUrl:[RRVideoViewController onlineMovie]];
      else
        [vidController setMovieUrl:[RRVideoViewController localMovie]];
    }
  }
  
  
  //setup the application preferences and user defaults
  userDefaults = [NSUserDefaults standardUserDefaults];
  if([userDefaults objectForKey:lastTabUserDefaultString]){
    NSInteger tabNum = [userDefaults integerForKey:lastTabUserDefaultString];
    tabBarController.selectedIndex = tabNum;
    [self.tabBarController.selectedViewController viewDidAppear:YES];
  }
  
}

- (void)dealloc {
  [tabBarController release];
  [window release];
  [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // save user data to NSDefaults
  NSLog(@"We are terminating");
  [userDefaults setInteger:[tabBarController selectedIndex] forKey:lastTabUserDefaultString];
}

@end
