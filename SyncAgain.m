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

@synthesize timer, syncer, lblSync, doFullSync;

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
	self.doFullSync = FALSE;
	[self loadSync];
}

- (void)loadSync {
	if ([[bSettings sharedbSettings] connectedToInternet]) {
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"DoFullSync", @"DoFullSync") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.YES", @"UI.YES") otherButtonTitles:NSLocalizedString(@"UI.NO", @"UI.NO"), nil];
		alert.tag = 2;
		[alert show];
	}
	else {
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"OfflineMode", @"OfflineMode") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
		alert.tag = 1;
		[alert show];
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
	[syncer startSync:self.doFullSync];
}

- (void)syncFinished:(id)sender {
	[self finishSync];
}

- (void)syncError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SyncError", @"SyncError"), errorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
	alert.tag = 2;
	[alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 1 && buttonIndex == 1)
		[self loadSync];
	else if (actionSheet.tag == 2) {
		if (buttonIndex == 1)
			doFullSync = FALSE;
		else
			doFullSync = TRUE;
		[self performSelector:@selector(startSync) withObject:nil afterDelay:1.0];
	}
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
	syncer = nil;
	lblSync = nil;
    [super viewDidUnload];
}


@end
