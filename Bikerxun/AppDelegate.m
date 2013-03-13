//
//  AppDelegate.m
//  Bikerxun
//
//  Created by Bobie on 3/13/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Beintoo.h"
#import "BeintooDevice.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     * You have to pass a settings dictionary with (see example below):
     
     * - BeintooActiveFeatures: the list of features that you want on your dashboard
     * - BeintooApplicationWindow: the key window of the app
     * - BeintooAppOrientation: the starting app orientation
     * - BeintooAchievementNotification: 1 or 0 respectively if you want the unlock achievement notifications or not
     * - BeintooLoginNotification: 1 or 0 respectively if you want the playerLogin notification or not
     * - BeintooScoreNotification: 1 or 0 respectively if you want the submitScore notification or not
     * - BeintooNoRewardNotification: 1 if you want a notification when no reward is retrieved, 0 if not
     * - BeintooForceRegistration: 1 if you want that the user will need to register to use all the features of Beintoo. 0 if you want to show a subset of features even for unregistered users (logged in through the [BeintooPlayer login]
     * - BeintooNotificationPosition: you can choose between BeintooNotificationPositionTop or BeintooNotificationPositionBottom
     */
    
    NSArray	*beintooFeatures = [NSArray arrayWithObjects:   BFEATURE_PROFILE,
                                BFEATURE_MARKETPLACE,
                                BFEATURE_LEADERBOARD,
                                BFEATURE_WALLET,
                                BFEATURE_CHALLENGES,
                                BFEATURE_ACHIEVEMENTS,
                                BFEATURE_TIPSANDFORUM, nil];
	
	NSDictionary *beintooSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
									 beintooFeatures,   BeintooActiveFeatures,
									 window,            BeintooApplicationWindow,
                                     [NSNumber numberWithInt:1], BeintooAchievementNotification,
                                     [NSNumber numberWithInt:1], BeintooLoginNotification,
                                     [NSNumber numberWithInt:1], BeintooScoreNotification,
                                     [NSNumber numberWithInt:0], BeintooNoRewardNotification,
                                     [NSNumber numberWithInt:0], BeintooDismissAfterRegistration,
                                     [NSNumber numberWithInt:0], BeintooForceRegistration,
                                     [NSNumber numberWithInt:BeintooNotificationPositionBottom], BeintooNotificationPosition,
									 [NSNumber numberWithInt:UIInterfaceOrientationPortrait], BeintooAppOrientation,
									 nil];
    
	sampleDelegate = [[BeintooDelegate alloc] init];
	
    [Beintoo initWithApiKey:@"2eeb4805d1aafdcf2b2d0c3abb846833" andApiSecret:nil andBeintooSettings:beintooSettings andMainDelegate:sampleDelegate];
    
    /*  UNCOMMENT the line below to use Beintoo in our testing environment sandbox
     *
     *   [Beintoo switchBeintooToSandbox];
     *
     *   Every user registered, every submit score and all the other operations will not be shown on
     *   real environment.
     *   COMMENT or DELETE that line, to start Beintoo on real environment.
     *   Rememeber to COMMENT or DELETE that line before submitting your app in App Store.
     *
     */
    
#ifdef BEINTOO_ARC_AVAILABLE
#else
    [beintooSettings release];
#endif
    
    // Override point for customization after application launch.
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
