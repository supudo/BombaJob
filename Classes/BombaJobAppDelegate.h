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
	NSString *oauthVerifier_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) MapCoordinates *mapCoordinates;
@property (nonatomic, readwrite, copy) NSString *oauthVerifier;

- (void)loadingFinished;

@end

extern BombaJobAppDelegate *appDelegate;
