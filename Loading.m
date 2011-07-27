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

@synthesize timer, webService, lblLoading;

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
	if ([bSettings sharedbSettings].doSync)
		self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(startSyncTimer) userInfo:nil repeats:NO];
	else
		[self finishSync];
}

- (void)startSyncTimer {
	if (self.webService == nil)
		self.webService = [[WebService alloc] init];
	[self.webService setDelegate:self];
	[self.webService getCategories];
}

-(void)finishSync {
	[self startTabApp];
}

- (void)serviceError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"SyncError", @"SyncError"), errorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)getCategoriesFinished:(id)sender {
	[self finishSync];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	timer = nil;
	[timer release];
	webService = nil;
	[webService release];
	lblLoading = nil;
	[lblLoading release];
    [super viewDidUnload];
}

- (void)dealloc {
	[timer release];
	[webService release];
	[lblLoading release];
    [super dealloc];
}

@end
