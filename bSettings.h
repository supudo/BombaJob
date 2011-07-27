//
//  bSettings.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "CurrentOffer.h"

@interface bSettings : NSObject {
	BOOL inDebugMode, sdlNewJobs, sdlJobs, sdlPeople, doSync, currentPostOfferResult;
	NSString *ServicesURL, *BuildVersion, *currentPostOfferResponse;
	float LocationLatitude, LocationLongtitude;
	CurrentOffer *currentOffer;
}

@property BOOL inDebugMode, sdlNewJobs, sdlJobs, sdlPeople, doSync, currentPostOfferResult;
@property (nonatomic, retain) NSString *ServicesURL, *BuildVersion, *currentPostOfferResponse;
@property float LocationLatitude, LocationLongtitude;
@property (nonatomic, retain) CurrentOffer *currentOffer;

- (void)LogThis: (NSString *)log;
- (BOOL)connectedToInternet;
- (NSString *)getOfferDate:(NSDate *)offerDate;
- (BOOL)validEmail:(NSString *)email sitrictly:(BOOL)stricterFilter;
- (void)roundButtonCorners:(UIControl *)control withColor:(UIColor *)color;
- (void)clearPostData;
- (void)startLoading:(UIView *)view;
- (void)stopLoading:(UIView *)view;

+ (bSettings *)sharedbSettings;

@end
