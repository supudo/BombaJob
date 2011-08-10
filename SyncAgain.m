//
//  SyncAgain.m
//  BombaJob
//
//  Created by supudo on 8/3/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "SyncAgain.h"
#import "BlackAlertView.h"

@implementation SyncAgain

@synthesize timer, syncer, lblSync;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Sync", @"Sync");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	[self.lblSync setText:NSLocalizedString(@"SyncInProgress", @"SyncInProgress")];
	[self.lblSync setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.hidesBackButton = YES;
	[self loadSync];
}

- (void)loadSync {
	if ([[bSettings sharedbSettings] connectedToInternet])
		[self performSelector:@selector(startSync) withObject:nil afterDelay:1.0];
	else {
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"OfflineMode", @"OfflineMode") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
		alert.tag = 1;
		[alert show];
		[alert release];
	}
}

- (void)startSync {
	if ([bSettings sharedbSettings].doSync && [bSettings sharedbSettings].stInitSync)
		self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(startSyncTimer) userInfo:nil repeats:NO];
	else
		[self syncFinished:nil];
}

- (void)startSyncTimer {
	if (syncer == nil)
		syncer = [[Sync alloc] init];
	[syncer setDelegate:self];
	[syncer startSync];
}

- (void)syncFinished:(id)sender {
	[self finishSync];
}

- (void)syncError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SyncError", @"SyncError"), errorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
	alert.tag = 2;
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 1 && buttonIndex == 1)
		[self loadSync];
	else
		[self finishSync];
}

- (void)finishSync {
	[bSettings sharedbSettings].sdlNewJobs = FALSE;
	[bSettings sharedbSettings].sdlJobs = FALSE;
	[bSettings sharedbSettings].sdlPeople = FALSE;

	[self.navigationController popToRootViewControllerAnimated:NO];
	[[[appDelegate tabBarController].viewControllers objectAtIndex:0] viewWillAppear:YES];
	[appDelegate tabBarController].selectedIndex = 0;
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
	timer = nil;
	[timer release];
	syncer = nil;
	[syncer release];
	lblSync = nil;
	[lblSync release];
    [super viewDidUnload];
}

- (void)dealloc {
	[timer release];
	[syncer release];
	[lblSync release];
    [super dealloc];
}

@end
