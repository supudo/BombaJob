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

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"MainNavTitle", @"MainNavTitle");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	[self.lblLoading setFont:[UIFont fontWithName:@"Ubuntu" size:30]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self performSelector:@selector(startSync) withObject:nil afterDelay:1.0];
}

- (void)startSync {
	if ([bSettings sharedbSettings].doSync && [bSettings sharedbSettings].stInitSync)
		self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(startSyncTimer) userInfo:nil repeats:NO];
	else
		[self syncFinished:nil];
}

- (void)startSyncTimer {
	if (self.syncer == nil)
		self.syncer = [[Sync alloc] init];
	[self.syncer setDelegate:self];
	[self.syncer startSync];
}

- (void)syncFinished:(id)sender {
	[self startTabApp];
}

- (void)syncError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SyncError", @"SyncError"), errorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:NSLocalizedString(@"UI.Retry", @"UI.Retry"), nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self startTabApp];
}

- (void)startTabApp {
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
	
	UINavigationController *moreController = appDelegate.tabBarController.moreNavigationController;
	moreController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	appDelegate.tabBarController.customizableViewControllers = nil;
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
