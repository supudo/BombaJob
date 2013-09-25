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
	BOOL inDebugMode, sdlNewJobs, sdlJobs, sdlPeople, doSync, currentPostOfferResult, shouldRotate;
	BOOL stPrivateData, stGeoLocation, stInitSync, stOnlineSearch, stInAppEmail, stShowCategories, stShowBanners;
	NSString *ServicesURL, *BuildVersion, *NewAppVersion, *currentPostOfferResponse, *languageCulture;
	float LocationLatitude, LocationLongtitude;
	CurrentOffer *currentOffer;
	NSMutableArray *latestSearchResults;
}

@property BOOL inDebugMode, sdlNewJobs, sdlJobs, sdlPeople, doSync, currentPostOfferResult, shouldRotate;
@property BOOL stPrivateData, stGeoLocation, stInitSync, stOnlineSearch, stInAppEmail, stShowCategories, stShowBanners;
@property (nonatomic, strong) NSString *ServicesURL, *BuildVersion, *NewAppVersion, *currentPostOfferResponse, *languageCulture;
@property float LocationLatitude, LocationLongtitude;
@property (nonatomic, strong) CurrentOffer *currentOffer;
@property (nonatomic, strong) NSMutableArray *latestSearchResults;

- (void)LogThis:(NSString *)log, ...;
- (BOOL)connectedToInternet;
- (NSString *)getOfferDate:(NSDate *)offerDate;
- (BOOL)validEmail:(NSString *)email sitrictly:(BOOL)stricterFilter;
- (void)roundButtonCorners:(UIControl *)control withColor:(UIColor *)color;
- (void)roundButtonCornersTextView:(UITextView *)txtView withColor:(UIColor *)color;
- (void)clearPostData;
- (void)startLoading:(UIView *)view;
- (void)stopLoading:(UIView *)view;
- (NSString *)stripHTMLtags:(NSString *)txt;
- (NSString *)getSetting:(NSString *)name;

+ (bSettings *)sharedbSettings;

@end
