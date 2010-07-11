//
//  RugRatAppDelegate.m
//  RugRat
//
//  Created by Demi Raven on 11/8/09.
//  Copyright BitSyrup 2009. All rights reserved.
//

#import "RugRatAppDelegate.h"
#import "RRVideoViewController.h"
#import "RRDatabaseInterface.h"
#import "RRLog.h"

static NSString *const lastTabUserDefaultString = @"LastTab";

@implementation RugRatAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize userDefaults;

- (void) fadeOutSplash: (float_t) seconds {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:seconds];
    [splashView setAlpha:0];
    [UIView commitAnimations];

    [self performSelector:@selector(deleteSplash) withObject:nil afterDelay:seconds];
}

- (void) deleteSplash{
    [splashView removeFromSuperview];
    [splashView release];
    splashView = nil;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {

    // Override point for customization after application launch
    [window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];

    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [window addSubview:splashView];
    [window bringSubviewToFront:splashView];


    // do setup on view controllers
    // iterate through view controllers looking for movie player controllers
    // setup their urls
    [tabBarController setDelegate:self];
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


    //setup the db and read from it...
    [RRDatabaseInterface instance];
    [self fadeOutSplash:2.0];

}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // save user data to NSDefaults
    NSLog(@"We are terminating");
    [userDefaults setInteger:[self.tabBarController selectedIndex] forKey:lastTabUserDefaultString];
}



@end
