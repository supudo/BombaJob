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
	BOOL stPrivateData, stGeoLocation, stInitSync, stOnlineSearch, stInAppEmail, stShowCategories;
	NSString *ServicesURL, *BuildVersion, *currentPostOfferResponse;
	float LocationLatitude, LocationLongtitude;
	CurrentOffer *currentOffer;
	NSMutableArray *latestSearchResults;
	NSString *twitterOAuthConsumerKey, *twitterOAuthConsumerSecret;
}

@property BOOL inDebugMode, sdlNewJobs, sdlJobs, sdlPeople, doSync, currentPostOfferResult;
@property BOOL stPrivateData, stGeoLocation, stInitSync, stOnlineSearch, stInAppEmail, stShowCategories;
@property (nonatomic, retain) NSString *ServicesURL, *BuildVersion, *currentPostOfferResponse;
@property float LocationLatitude, LocationLongtitude;
@property (nonatomic, retain) CurrentOffer *currentOffer;
@property (nonatomic, retain) NSMutableArray *latestSearchResults;
@property (nonatomic, retain) NSString *twitterOAuthConsumerKey, *twitterOAuthConsumerSecret;

- (void)LogThis:(NSString *)log, ...;
- (BOOL)connectedToInternet;
- (NSString *)getOfferDate:(NSDate *)offerDate;
- (BOOL)validEmail:(NSString *)email sitrictly:(BOOL)stricterFilter;
- (void)roundButtonCorners:(UIControl *)control withColor:(UIColor *)color;
- (void)roundButtonCornersTextView:(UITextView *)txtView withColor:(UIColor *)color;
- (void)clearPostData;
- (void)startLoading:(UIView *)view;
- (void)stopLoading:(UIView *)view;

+ (bSettings *)sharedbSettings;

@end
