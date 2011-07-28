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
@synthesize loadingView;
@synthesize mapCoordinates;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	appDelegate = self;
	
	if (![bSettings sharedbSettings].inDebugMode && [bSettings sharedbSettings].stGeoLocation) {
		self.mapCoordinates = [[MapCoordinates alloc] init];
		[self.mapCoordinates startCoor];
	}

	[self.window addSubview:self.loadingView.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc {
    [tabBarController release];
    [window release];
	[loadingView release];
	[mapCoordinates release];
    [super dealloc];
}

@end
