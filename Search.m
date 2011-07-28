//
//  Search.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Search.h"

@implementation Search

@synthesize lblFreelance, txtSearch, swFreelance, btnSearch, webService;

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
	if (self.webService == nil)
		self.webService = [[WebService alloc] init];
	[self.webService setDelegate:self];
	[self.webService searchOffers:self.txtSearch.text freelance:[swFreelance isOn]];
}

- (void)searchOffersFinished:(id)sender results:(NSMutableArray *)offers {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark System

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
	webService = nil;
	[webService release];
    [super viewDidUnload];
}

- (void)dealloc {
	[lblFreelance release];
	[txtSearch release];
	[swFreelance release];
	[btnSearch release];
	[webService release];
    [super dealloc];
}

@end
