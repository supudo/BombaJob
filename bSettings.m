//
//  bSettings.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

@implementation bSettings

@synthesize inDebugMode, sdlNewJobs, sdlJobs, sdlPeople, doSync, currentPostOfferResult, currentPostOfferResponse;
@synthesize ServicesURL, BuildVersion, LocationLatitude, LocationLongtitude, currentOffer;

SYNTHESIZE_SINGLETON_FOR_CLASS(bSettings);

- (void) LogThis: (NSString *)log {
	if (self.inDebugMode)
		NSLog(@"[_____BombaJob-DEBUG] : %@", log);
}

- (BOOL)connectedToInternet {
	Reachability *r = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL result = FALSE;
	if (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN)
	    result = TRUE;
	return result;
}

- (id) init {
	if (self = [super init]) {
		self.inDebugMode = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"BMInDebugMode"] boolValue];
		self.sdlNewJobs = FALSE;
		self.sdlJobs = FALSE;
		self.sdlPeople = FALSE;
		self.doSync = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"BMDoSync"] boolValue];
		self.ServicesURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BMServicesURL"];
		self.BuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
		self.currentPostOfferResult = FALSE;
		self.currentPostOfferResponse = @"";
		self.LocationLatitude = 0.f;
		self.LocationLongtitude = 0.f;
		self.currentOffer = [[CurrentOffer alloc] init];
	}
	return self;
}

#pragma mark -
#pragma mark Helpers

- (NSString *)getOfferDate:(NSDate *)offerDate {
	NSString *dtString = @"";
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd"];
	dtString = [df stringFromDate:offerDate];
	[df setDateFormat:@"m"];
	NSString *monthLabel = [NSString stringWithFormat:@"Months_Short_%@", [df stringFromDate:offerDate]];
	dtString = [NSString stringWithFormat:@"%@ %@", dtString, NSLocalizedString(monthLabel, monthLabel)];
	[df setDateFormat:@"yyyy"];
	dtString = [NSString stringWithFormat:@"%@ %@", dtString, [df stringFromDate:offerDate]];
	[df release];
	return dtString;
}

- (BOOL)validEmail:(NSString *)email sitrictly:(BOOL)stricterFilter {
	// stricterFilter - Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

- (void)roundButtonCorners:(UIControl *)control withColor:(UIColor *)color {
	[[control layer] setCornerRadius:8.0f];
	[[control layer] setMasksToBounds:YES];
	[[control layer] setBorderWidth:1.0f];
	[[control layer] setBorderColor:[color CGColor]];
}

- (void)clearPostData {
	self.currentOffer.OfferID = 0;
	self.currentOffer.CategoryID = 0;
	self.currentOffer.HumanYn = TRUE;
	self.currentOffer.FreelanceYn = FALSE;
	self.currentOffer.Title = @"";
	self.currentOffer.Email = @"";
	self.currentOffer.Positivism = @"";
	self.currentOffer.Negativism = @"";
	self.currentOffer.CategoryTitle = @"";
	self.currentOffer.PublishDate = nil;
}

- (void)startLoading:(UIView *)view {
	UIView *overlayView = [[UIView alloc] initWithFrame:view.frame];
	overlayView.backgroundColor = [UIColor blackColor];
	overlayView.alpha = 0.4;
	overlayView.tag = 999;

	UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loading setFrame:CGRectMake(overlayView.frame.size.width / 2 - 17, overlayView.frame.size.height / 2 - 17, 37, 37)];
	[loading startAnimating];
	[overlayView addSubview:loading];
	[loading release];

	[view addSubview:overlayView];
	[overlayView release];
}

- (void)stopLoading:(UIView *)view {
	for (int i=0; i<[view.subviews count]; i++) {
		UIView *v = [view.subviews objectAtIndex:i];
		if (v.tag == 999)
			[v removeFromSuperview];
	}
}

@end
