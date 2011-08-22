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
@synthesize oauthVerifier = oauthVerifier_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	appDelegate = self;
	
	[self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
	
	if (![bSettings sharedbSettings].inDebugMode && [bSettings sharedbSettings].stGeoLocation) {
		mapCoordinates = [[MapCoordinates alloc] init];
		[mapCoordinates startCoor];
	}
	
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

- (void)dealloc {
    [tabBarController release];
    [window release];
	[mapCoordinates release];
    [super dealloc];
}

@end
