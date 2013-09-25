//
//  Search.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Search.h"
#import "SearchResults.h"
#import "BlackAlertView.h"
#import "SearchGeo.h"

@implementation Search

@synthesize lblFreelance, txtSearch, swFreelance, btnSearch, btnSearchGeo;

#pragma mark -
#pragma mark Workers

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Search", @"Search");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	[lblFreelance setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[txtSearch setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[btnSearch.titleLabel setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
	[btnSearchGeo.titleLabel setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
    btnSearchGeo.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	lblFreelance.text = NSLocalizedString(@"Search.Freelance", @"Search.Freelance");
	[btnSearch setTitle:NSLocalizedString(@"Search.Search", @"Search.Search") forState:UIControlStateNormal];
	[btnSearchGeo setTitle:NSLocalizedString(@"Search.SearchGeo", @"Search.SearchGeo") forState:UIControlStateNormal];
	if (![bSettings sharedbSettings].stGeoLocation)
		btnSearchGeo.hidden = YES;
}

- (IBAction)iboSearch:(id)sender {
	if ([[bSettings sharedbSettings] connectedToInternet]) {
		SearchResults *tvc = [[SearchResults alloc] initWithNibName:@"SearchResults" bundle:nil];
		tvc.searchTerm = self.txtSearch.text;
		tvc.freelanceOn = [swFreelance isOn];
		tvc.searchOffline = NO;
		[[self navigationController] pushViewController:tvc animated:YES];
	}
	else {
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"OfflineMode", @"OfflineMode") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
		alert.tag = 1;
		[alert show];
	}
}

- (IBAction)iboSearchGeo:(id)sender {
	if ([[bSettings sharedbSettings] connectedToInternet])
		[self doGeoSearch];
	else {
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"OfflineMode_NoGeoSearch", @"OfflineMode_NoGeoSearch") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
		alert.tag = 2;
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 1) {
		if (buttonIndex == 1)
			[self iboSearch:nil];
		else {
			SearchResults *tvc = [[SearchResults alloc] initWithNibName:@"SearchResults" bundle:nil];
			tvc.searchTerm = self.txtSearch.text;
			tvc.freelanceOn = [swFreelance isOn];
			tvc.searchOffline = YES;
			[[self navigationController] pushViewController:tvc animated:YES];
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Geo search

- (void)doGeoSearch {
#if TARGET_IPHONE_SIMULATOR
	[self coordinatesUpdate:42.614791 latitude:23.248014];
#else
	[[bSettings sharedbSettings] startLoading:self.view];
	[appDelegate.mapCoordinates setDelegate:self];
	[appDelegate.mapCoordinates startCoor];
#endif
}

- (void)coordinatesUpdate:(float)longitude latitude:(float)latitude {
	[bSettings sharedbSettings].LocationLatitude = latitude;
	[bSettings sharedbSettings].LocationLongtitude = longitude;
	[[bSettings sharedbSettings] LogThis:@"Map coordinates - %f - %f", latitude, longitude];
	SearchGeo *tvc = [[SearchGeo alloc] initWithNibName:@"SearchGeo" bundle:nil];
	tvc.pinsDropped = NO;
	tvc.searchTerm = self.txtSearch.text;
	tvc.freelanceOn = [swFreelance isOn];
	tvc.searchOffline = NO;
	[[self navigationController] pushViewController:tvc animated:YES];
}

#pragma mark -
#pragma mark System

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ? NO : [bSettings sharedbSettings].shouldRotate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	lblFreelance = nil;
	txtSearch = nil;
	swFreelance = nil;
	btnSearch = nil;
	btnSearchGeo = nil;
    [super viewDidUnload];
}


@end
