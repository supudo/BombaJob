//
//  bSettings.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "DBManagedObjectContext.h"
#import "dbSettings.h"

@implementation bSettings

@synthesize inDebugMode, sdlNewJobs, sdlJobs, sdlPeople, doSync, currentPostOfferResult, currentPostOfferResponse;
@synthesize stPrivateData, stGeoLocation, stInitSync, stOnlineSearch, stInAppEmail, stShowCategories;
@synthesize ServicesURL, BuildVersion, LocationLatitude, LocationLongtitude, currentOffer, latestSearchResults;
@synthesize twitterOAuthConsumerKey, twitterOAuthConsumerSecret, facebookAppID, facebookAppSecret;

SYNTHESIZE_SINGLETON_FOR_CLASS(bSettings);

- (void)LogThis:(NSString *)log, ... {
	if (self.inDebugMode) {
		NSString *output;
		va_list ap;
		va_start(ap, log);
		output = [[NSString alloc] initWithFormat:log arguments:ap];
		va_end(ap);
		NSLog(@"[_____BombaJob-DEBUG] : %@", output);
		[output release];
	}
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
		
		self.stPrivateData = TRUE;
		self.stGeoLocation = TRUE;
		self.stInitSync = TRUE;
		self.stOnlineSearch = TRUE;
		self.stInAppEmail = FALSE;
		self.stShowCategories = TRUE;
		
		self.twitterOAuthConsumerKey = @"OVvHQ1wio8LZklS5mRUuA";
		self.twitterOAuthConsumerSecret = @"zZm0RsfzkLpF3FYnxcM3BDZdxHA6sPLoPiTcBvohUEo";
		self.facebookAppID = @"162884250446512";
		self.facebookAppSecret = @"a082d8bbc8e98cf63f8a1711ccbafe82";

		DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
		dbSettings *ent;
		
		ent = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"StorePrivateData"]];
		if (ent != nil && ![ent.SValue isEqualToString:@""])
			self.stPrivateData = [ent.SValue boolValue];
		else {
			ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
			[ent setSName:@"StorePrivateData"];
			[ent setSValue:@"TRUE"];
			self.stPrivateData = TRUE;
		}
		
		ent = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"SendGeo"]];
		if (ent != nil && ![ent.SValue isEqualToString:@""])
			self.stGeoLocation = [ent.SValue boolValue];
		else {
			ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
			[ent setSName:@"SendGeo"];
			[ent setSValue:@"TRUE"];
			self.stGeoLocation = TRUE;
		}
		
		ent = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"InitSync"]];
		if (ent != nil && ![ent.SValue isEqualToString:@""])
			self.stInitSync = [ent.SValue boolValue];
		else {
			ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
			[ent setSName:@"InitSync"];
			[ent setSValue:@"TRUE"];
			self.stInitSync = TRUE;
		}
		
		ent = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"OnlineSearch"]];
		if (ent != nil && ![ent.SValue isEqualToString:@""])
			self.stOnlineSearch = [ent.SValue boolValue];
		else {
			ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
			[ent setSName:@"OnlineSearch"];
			[ent setSValue:@"TRUE"];
			self.stOnlineSearch = TRUE;
		}
		
		ent = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"InAppEmail"]];
		if (ent != nil && ![ent.SValue isEqualToString:@""])
			self.stInAppEmail = [ent.SValue boolValue];
		else {
			ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
			[ent setSName:@"InAppEmail"];
			[ent setSValue:@"FALSE"];
			self.stInAppEmail = TRUE;
		}
		
		ent = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"ShowCategories"]];
		if (ent != nil && ![ent.SValue isEqualToString:@""])
			self.stShowCategories = [ent.SValue boolValue];
		else {
			ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
			[ent setSName:@"ShowCategories"];
			[ent setSValue:@"TRUE"];
			self.stShowCategories = TRUE;
		}

		NSError *error = nil;
		if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
			[[bSettings sharedbSettings] LogThis:@"Error while saving the account info: %@", [error userInfo]];
			abort();
		}

		self.doSync = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"BMDoSync"] boolValue];
		self.ServicesURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BMServicesURL"];
		self.BuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
		self.currentPostOfferResult = FALSE;
		self.currentPostOfferResponse = @"";
		self.LocationLatitude = 0.f;
		self.LocationLongtitude = 0.f;
		self.currentOffer = [[CurrentOffer alloc] init];
		self.latestSearchResults = [[NSMutableArray alloc] init];
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

- (void)roundButtonCornersTextView:(UITextView *)txtView withColor:(UIColor *)color {
	[[txtView layer] setCornerRadius:8.0f];
	[[txtView layer] setMasksToBounds:YES];
	[[txtView layer] setBorderWidth:1.0f];
	[[txtView layer] setBorderColor:[color CGColor]];
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
