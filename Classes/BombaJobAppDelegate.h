//
//  BombaJobAppDelegate.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapCoordinates.h"

@interface BombaJobAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	MapCoordinates *mapCoordinates;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, strong) MapCoordinates *mapCoordinates;

- (void)loadingFinished;

@end

extern BombaJobAppDelegate *appDelegate;
