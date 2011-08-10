//
//  Loading.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Loading.h"
#import "BlackAlertView.h"

@implementation Loading

@synthesize timer, syncer, lblLoading;

#pragma mark -
#pragma mark Workers

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"MainNavTitle", @"MainNavTitle");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	[self.lblLoading setFont:[UIFont fontWithName:@"Ubuntu" size:30]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
	[self startTabApp];
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
		[self startTabApp];
}

- (void)startTabApp {
	/*
	UIView *tabBarView = [[appDelegate tabBarController] view];
	[tabBarView setCenter:CGPointMake(tabBarView.center.x, tabBarView.center.y)];
	tabBarView.alpha = 0;
	[[appDelegate tabBarController] viewWillAppear:YES];
	[appDelegate tabBarController].selectedIndex = 0;
	[self.view.superview addSubview:tabBarView];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:.2];
	[UIView setAnimationDuration:.4];
	tabBarView.alpha = 1;
	[UIView commitAnimations];
	 */
	
	UINavigationController *moreController = appDelegate.tabBarController.moreNavigationController;
	moreController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	appDelegate.tabBarController.customizableViewControllers = nil;
	
	[appDelegate loadingFinished];
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
	lblLoading = nil;
	[lblLoading release];
    [super viewDidUnload];
}

- (void)dealloc {
	[timer release];
	[syncer release];
	[lblLoading release];
    [super dealloc];
}

@end
