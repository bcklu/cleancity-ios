//
//  AppDelegate_iPhone.m
//  CleanCity
//
//  Created by Martin Gratzer on 18.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "CCDebugMacros.h"
#import "CCPostView.h"
#import "FBConnect.h"

@implementation AppDelegate_iPhone

@synthesize window, postViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after application launch.	
	CCPostView *postView = [[CCPostView alloc] init];
	postView.view.frame = CGRectMake(0, 20, 320, 460);

	self.postViewController = postView;
	[postView release];
	[self.window addSubview:postView.view];

    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	Facebook *facebook = [[Facebook alloc] initWithAppId:FB_APP_ID];
	[facebook handleOpenURL:url];
	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:@"accesstoken"];
	CCLOG(@"Got Token: %@", facebook.accessToken);
	[facebook release];
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	self.postViewController = nil;
    [window release];
    [super dealloc];
}


@end
