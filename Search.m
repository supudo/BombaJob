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

@implementation Search

@synthesize lblFreelance, txtSearch, swFreelance, btnSearch;

#pragma mark -
#pragma mark Workers

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Search", @"Search");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	[lblFreelance setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[txtSearch setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[btnSearch.titleLabel setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	lblFreelance.text = NSLocalizedString(@"Search.Freelance", @"Search.Freelance");
}

- (IBAction)iboSearch:(id)sender {
	if ([[bSettings sharedbSettings] connectedToInternet]) {
		SearchResults *tvc = [[SearchResults alloc] initWithNibName:@"SearchResults" bundle:nil];
		tvc.searchTerm = self.txtSearch.text;
		tvc.freelanceOn = [swFreelance isOn];
		tvc.searchOffline = NO;
		[[self navigationController] pushViewController:tvc animated:YES];
		[tvc release];
	}
	else {
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"OfflineMode", @"OfflineMode") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
		alert.tag = 1;
		[alert show];
		[alert release];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1)
		[self iboSearch:nil];
	else {
		SearchResults *tvc = [[SearchResults alloc] initWithNibName:@"SearchResults" bundle:nil];
		tvc.searchTerm = self.txtSearch.text;
		tvc.freelanceOn = [swFreelance isOn];
		tvc.searchOffline = YES;
		[[self navigationController] pushViewController:tvc animated:YES];
		[tvc release];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
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
	[lblFreelance release];
	txtSearch = nil;
	[txtSearch release];
	swFreelance = nil;
	[swFreelance release];
	btnSearch = nil;
	[btnSearch release];
    [super viewDidUnload];
}

- (void)dealloc {
	[lblFreelance release];
	[txtSearch release];
	[swFreelance release];
	[btnSearch release];
    [super dealloc];
}

@end
