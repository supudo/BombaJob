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
#import "dbTextContent.h"
#import "DBManagedObjectContext.h"

@implementation Settings

@synthesize lblPrivateData, lblGeo, lblSync, lblSearch, lblInAppEmail, lblShowCategories;
@synthesize swPrivateData, swGeo, swSync, swSearch, swInAppEmail, swShowCategories;
@synthesize helpScreen;

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
	[lblInAppEmail setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[lblShowCategories setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	lblPrivateData.text = NSLocalizedString(@"About.PrivateData", @"");
	lblGeo.text = NSLocalizedString(@"About.Geo", @"");
	lblSync.text = NSLocalizedString(@"About.Sync", @"");
	lblSearch.text = NSLocalizedString(@"About.Search", @"");
	lblInAppEmail.text = NSLocalizedString(@"About.InAppEmail", @"");
	lblShowCategories.text = NSLocalizedString(@"About.ShowCategories", @"");
	[swPrivateData setOn:[bSettings sharedbSettings].stPrivateData];
	[swGeo setOn:[bSettings sharedbSettings].stGeoLocation];
	[swSync setOn:[bSettings sharedbSettings].stInitSync];
	[swSearch setOn:[bSettings sharedbSettings].stOnlineSearch];
	[swInAppEmail setOn:[bSettings sharedbSettings].stInAppEmail];
	[swShowCategories setOn:[bSettings sharedbSettings].stShowCategories];
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

- (IBAction) iboInAppEmail:(id)sender {
	[bSettings sharedbSettings].stInAppEmail = [swInAppEmail isOn];
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSettings *entPD = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"InAppEmail"]];
	[entPD setSValue:(([swInAppEmail isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
		abort();
	}
}

- (IBAction) iboShowCategories:(id)sender {
	[bSettings sharedbSettings].stShowCategories = [swShowCategories isOn];
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSettings *entPD = (dbSettings *)[dbManagedObjectContext getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"ShowCategories"]];
	[entPD setSValue:(([swShowCategories isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
		abort();
	}
}

#pragma mark -
#pragma mark Help buttons

- (IBAction) iboHelpPrivateData:(id)sender {
	dbTextContent *tc = (dbTextContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"TextContent" predicate:[NSPredicate predicateWithFormat:@"CID=%@", @"36"]];
	[self showHelp:NSLocalizedString(@"About.PrivateData", @"About.PrivateData") withContent:tc.Content];
}

- (IBAction) iboHelpGeoData:(id)sender {
	dbTextContent *tc = (dbTextContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"TextContent" predicate:[NSPredicate predicateWithFormat:@"CID=%@", @"37"]];
	[self showHelp:NSLocalizedString(@"About.Geo", @"About.Geo") withContent:tc.Content];
}

- (IBAction) iboHelpSyncData:(id)sender {
	dbTextContent *tc = (dbTextContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"TextContent" predicate:[NSPredicate predicateWithFormat:@"CID=%@", @"38"]];
	[self showHelp:NSLocalizedString(@"About.Sync", @"About.Sync") withContent:tc.Content];
}

- (IBAction) iboHelpSearch:(id)sender {
	dbTextContent *tc = (dbTextContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"TextContent" predicate:[NSPredicate predicateWithFormat:@"CID=%@", @"39"]];
	[self showHelp:NSLocalizedString(@"About.Search", @"About.Search") withContent:tc.Content];
}

- (IBAction) iboHelpInAppEmail:(id)sender {
	dbTextContent *tc = (dbTextContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"TextContent" predicate:[NSPredicate predicateWithFormat:@"CID=%@", @"40"]];
	[self showHelp:NSLocalizedString(@"About.InAppEmail", @"About.InAppEmail") withContent:tc.Content];
}

- (IBAction) iboHelpShowCategories:(id)sender {
	dbTextContent *tc = (dbTextContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"TextContent" predicate:[NSPredicate predicateWithFormat:@"CID=%@", @"41"]];
	[self showHelp:NSLocalizedString(@"About.ShowCategories", @"About.ShowCategories") withContent:tc.Content];
}

- (void)showHelp:(NSString *)helpTitle withContent:(NSString *)helpContent {
	if (self.helpScreen == nil) {
		self.helpScreen = [[UIActionSheet alloc] initWithTitle:@"Help" delegate:self cancelButtonTitle:NSLocalizedString(@"UI.Close", @"UI.Close") destructiveButtonTitle:nil otherButtonTitles:nil];
		UITextView *txt = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, 300, 110)];
		[txt setEditable:NO];
		[txt setText:@""];
		[txt setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
		[[bSettings sharedbSettings] roundButtonCornersTextView:txt withColor:[UIColor blackColor]];
		[self.helpScreen addSubview:txt];
		[txt release];
	}
	
	[self.helpScreen setTitle:helpTitle];
	for (UIView *v in self.helpScreen.subviews) {
		if ([v isKindOfClass:[UITextView class]])
			[((UITextView *)v) setText:helpContent];
	}
	[self.helpScreen showFromTabBar:appDelegate.tabBarController.tabBar];
	[self.helpScreen setBounds:CGRectMake(0, 0, 320, 350)];
	[self.helpScreen setMultipleTouchEnabled:YES];
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
	lblSearch = nil;
	[lblSearch release];
	lblInAppEmail = nil;
	[lblInAppEmail release];
	lblShowCategories = nil;
	[lblShowCategories release];
	swSearch = nil;
	[swSearch release];
	swPrivateData = nil;
	[swPrivateData release];
	swGeo = nil;
	[swGeo release];
	swSync = nil;
	[swSync release];
	swInAppEmail = nil;
	[swInAppEmail release];
	swShowCategories = nil;
	[swShowCategories release];
	helpScreen = nil;
	[helpScreen release];
    [super viewDidUnload];
}

- (void)dealloc {
	[lblPrivateData release];
	[lblGeo release];
	[lblSync release];
	[lblSearch release];
	[lblInAppEmail release];
	[lblShowCategories release];
	[swSearch release];
	[swPrivateData release];
	[swGeo release];
	[swSync release];
	[swInAppEmail release];
	[swShowCategories release];
	[helpScreen release];
    [super dealloc];
}

@end
