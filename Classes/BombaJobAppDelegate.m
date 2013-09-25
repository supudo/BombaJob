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
    application.applicationIconBadgeNumber = 0;
#endif

    Loading *lvc = [[Loading alloc] initWithNibName:@"Loading" bundle:nil];
    [tabBarController presentViewController:lvc animated:YES completion:nil];

    return YES;
}

- (void)loadingFinished {
    [tabBarController dismissViewControllerAnimated:YES completion:nil];
	tabBarController.moreNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[tabBarController.moreNavigationController setDelegate:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.navigationBar.topItem.rightBarButtonItem = nil;
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
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}

#pragma mark -


@end
