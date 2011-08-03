//
//  OfferMessage.m
//  BombaJob
//
//  Created by supudo on 7/5/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "OfferMessage.h"
#import <QuartzCore/QuartzCore.h>
#import "BlackAlertView.h"
#import "DBManagedObjectContext.h"

@implementation OfferMessage

@synthesize entOffer, searchOffer, webService, txtMessage;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = entOffer.Title;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendMessage)] autorelease];
	if (self.webService == nil)
		self.webService = [[WebService alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	txtMessage.font = [UIFont fontWithName:@"Ubuntu" size:14];
	txtMessage.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtMessage.layer.cornerRadius = 5;
	txtMessage.clipsToBounds = YES;
}

- (void)sendMessage {
	[webService setDelegate:self];
	if (searchOffer == nil)
		[webService postMessage:[entOffer.OfferID intValue] message:txtMessage.text];
	else
		[webService postMessage:searchOffer.OfferID message:txtMessage.text];
}

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"OfferMessageError", @"OfferMessageError")] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	alert.tag = 1;
	[alert show];
	[alert release];
}

- (void)postMessageFinished:(id)sender {
	if (searchOffer == nil) {
		DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
		dbJobOffer *entPD = (dbJobOffer *)[dbManagedObjectContext getEntity:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"OfferID = %@", entOffer.OfferID]];
		[entPD setSentMessageYn:[NSNumber numberWithInt:1]];
		NSError *error = nil;
		if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
			[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
			abort();
		}
	}
	else {
		for (SearchOffer *off in [bSettings sharedbSettings].latestSearchResults) {
			if (off.OfferID == searchOffer.OfferID)
				off.SentMessageYn = 1;
		}
	}

	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	entOffer = nil;
	[entOffer release];
	searchOffer = nil;
	[searchOffer release];
	webService = nil;
	[webService release];
	txtMessage = nil;
	[txtMessage release];
    [super viewDidUnload];
}

- (void)dealloc {
	[entOffer release];
	[searchOffer release];
	[webService release];
	[txtMessage release];
    [super dealloc];
}

@end
