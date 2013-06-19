//
//  AppDelegate.m
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "AppDelegate.h"

#import "LoadViewController.h"
#import "FeedStore.h"
#import "Feed.h"

@implementation AppDelegate

@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init the main window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Create the loading view controller
    LoadViewController * rootView = [[LoadViewController alloc] initWithNibName:@"LoadViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:rootView];
    self.window.rootViewController = self.navController;
    
    // Initialise the feed store. This is the source of all visible data.
    FeedStore * feedStore = [FeedStore singleton];
    if ([feedStore isEmpty] ) {
        [feedStore add:[[Feed alloc] initWithName:@"Multitouch Design" url:@"http://multitouchdesign.wordpress.com/feed/"]];
        [feedStore add:[[Feed alloc] initWithName:@"Bike Exif" url:@"http://bikeexif.com/feed"]];
        [feedStore add:[[Feed alloc] initWithName:@"Herman Miller" url:@"http://www.hermanmiller.com/discover/feed/"]];
        [feedStore add:[[Feed alloc] initWithName:@"The Inquisitr" url:@"http://www.inquisitr.com/feed"]];
    }
    rootView.feedStore = feedStore;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
