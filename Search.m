//
//  Search.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Search.h"
#import "SearchResults.h"

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
	SearchResults *tvc = [[SearchResults alloc] initWithNibName:@"SearchResults" bundle:nil];
	tvc.searchTerm = self.txtSearch.text;
	tvc.freelanceOn = [swFreelance isOn];
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
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
