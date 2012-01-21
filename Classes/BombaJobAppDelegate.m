//
//  BombaJobAppDelegate.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "BombaJobAppDelegate.h"
#import "Loading.h"

BombaJobAppDelegate *appDelegate;

@implementation BombaJobAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize mapCoordinates;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	appDelegate = self;
	
	[self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

    
#if TARGET_IPHONE_SIMULATOR
	if ([bSettings sharedbSettings].stGeoLocation)
		mapCoordinates = [[MapCoordinates alloc] init];
#else
	if (![bSettings sharedbSettings].inDebugMode && [bSettings sharedbSettings].stGeoLocation) {
		mapCoordinates = [[MapCoordinates alloc] init];
		[mapCoordinates startCoor];
	}
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    application.applicationIconBadgeNumber = 0;
#endif

    Loading *lvc = [[Loading alloc] initWithNibName:@"Loading" bundle:nil];
    [tabBarController presentModalViewController:lvc animated:NO];
    [lvc release];

    return YES;
}

- (void)loadingFinished {
    [tabBarController dismissModalViewControllerAnimated:YES];
	tabBarController.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[tabBarController.moreNavigationController setDelegate:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.navigationBar.topItem.rightBarButtonItem = nil;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[bSettings sharedbSettings]._facebookEngine handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[bSettings sharedbSettings]._facebookEngine handleOpenURL:url];
}

#pragma mark -
#pragma mark Notifications

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    [[bSettings sharedbSettings] LogThis:@"Notification received: %@", [userInfo description]];

    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification"
                                                            message:[NSString stringWithFormat:@"The application received this remote notification while it was running:\n%@",
                                                                     [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                                           delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[bSettings sharedbSettings] LogThis:@"Registered for remote notifications: %@", deviceToken];
    [bSettings sharedbSettings].apnsToken = deviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[bSettings sharedbSettings] LogThis:@"Fail to register for remote notifications: %@", error];
}

#pragma mark -

- (void)dealloc {
    [tabBarController release];
    [window release];
	[mapCoordinates release];
    [super dealloc];
}

@end
