//
//  BombaJobAppDelegate.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapCoordinates.h"

@class Loading;

@interface BombaJobAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	Loading *loadingView;
	MapCoordinates *mapCoordinates;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet Loading *loadingView;
@property (nonatomic, retain) MapCoordinates *mapCoordinates;

@end

extern BombaJobAppDelegate *appDelegate;
