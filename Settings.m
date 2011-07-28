//
//  Settings.m
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Settings.h"
#import "DBManagedObjectContext.h"
#import "dbSettings.h"

@implementation Settings

@synthesize lblPrivateData, lblGeo, lblSync;
@synthesize swPrivateData, swGeo, swSync;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Settings", @"Settings");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	[lblPrivateData setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[lblGeo setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[lblSync setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[lblSearch setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	lblPrivateData.text = NSLocalizedString(@"About.PrivateData", @"");
	lblGeo.text = NSLocalizedString(@"About.Geo", @"");
	lblSync.text = NSLocalizedString(@"About.Sync", @"");
	lblSearch.text = NSLocalizedString(@"About.Search", @"");
	[swPrivateData setOn:[bSettings sharedbSettings].stPrivateData];
	[swGeo setOn:[bSettings sharedbSettings].stGeoLocation];
	[swSync setOn:[bSettings sharedbSettings].stInitSync];
	[swSearch setOn:[bSettings sharedbSettings].stOnlineSearch];
}

- (IBAction) iboPrivateData:(id)sender {
	[bSettings sharedbSettings].stPrivateData = [swPrivateData isOn];
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSettings *entPD = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"StorePrivateData"]];
	[entPD setSValue:(([swPrivateData isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
		abort();
	}
}

- (IBAction) iboGeoData:(id)sender {
	[bSettings sharedbSettings].stGeoLocation = [swGeo isOn];
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSettings *entPD = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"SendGeo"]];
	[entPD setSValue:(([swGeo isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
		abort();
	}
}

- (IBAction) iboSyncData:(id)sender {
	[bSettings sharedbSettings].stInitSync = [swSync isOn];
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSettings *entPD = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"InitSync"]];
	[entPD setSValue:(([swSync isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
		abort();
	}
}

- (IBAction) iboSearch:(id)sender {
	[bSettings sharedbSettings].stOnlineSearch = [swSearch isOn];
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSettings *entPD = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"OnlineSearch"]];
	[entPD setSValue:(([swSearch isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
		abort();
	}
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	lblPrivateData = nil;
	[lblPrivateData release];
	lblGeo = nil;
	[lblGeo release];
	lblSync = nil;
	[lblSync release];
	swPrivateData = nil;
	[swPrivateData release];
	swGeo = nil;
	[swGeo release];
	swSync = nil;
	[swSync release];
    [super viewDidUnload];
}

- (void)dealloc {
	[lblPrivateData release];
	[lblGeo release];
	[lblSync release];
	[swPrivateData release];
	[swGeo release];
	[swSync release];
    [super dealloc];
}

@end
