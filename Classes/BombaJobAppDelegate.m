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
	
	if (![bSettings sharedbSettings].inDebugMode && [bSettings sharedbSettings].stGeoLocation) {
		mapCoordinates = [[MapCoordinates alloc] init];
		[mapCoordinates startCoor];
	}
	
    Loading *lvc = [[Loading alloc] initWithNibName:@"Loading" bundle:nil];
    [self.tabBarController presentModalViewController:lvc animated:NO];
    [lvc release];

    return YES;
}

- (void)loadingFinished {
    [self.tabBarController dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
	[mapCoordinates release];
    [super dealloc];
}

@end
