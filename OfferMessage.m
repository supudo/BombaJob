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

@implementation OfferMessage

@synthesize entOffer, webService, txtMessage;

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
	[webService postMessage:[entOffer.OfferID intValue] message:txtMessage.text];
}

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"OfferMessageError", @"OfferMessageError")] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	alert.tag = 1;
	[alert show];
	[alert release];
}

- (void)postMessageFinished:(id)sender {
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
	webService = nil;
	[webService release];
	txtMessage = nil;
	[txtMessage release];
    [super viewDidUnload];
}

- (void)dealloc {
	[entOffer release];
	[webService release];
	[txtMessage release];
    [super dealloc];
}

@end
