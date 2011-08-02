//
//  SearchResults.m
//  BombaJob
//
//  Created by supudo on 8/2/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "SearchResults.h"
#import "SearchOffer.h"
#import "Offer.h"

static NSString *kCellIdentifier = @"identifSearchResults";

@implementation SearchResults

@synthesize searchResults, webService, searchTerm, freelanceOn;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Search", @"Search");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadContent)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reloadContent];
}

- (void)reloadContent {
	[[bSettings sharedbSettings] startLoading:self.view];
	
	if (self.searchResults == nil)
		self.searchResults = [[NSMutableArray alloc] init];
	[self.searchResults removeAllObjects];

	if (self.webService == nil)
		self.webService = [[WebService alloc] init];
	[self.webService setDelegate:self];
	[self.webService searchOffers:self.searchTerm freelance:freelanceOn];
}

#pragma mark -
#pragma mark Delegates

- (void)searchOffersFinished:(id)sender results:(NSMutableArray *)offers {
	[[bSettings sharedbSettings] stopLoading:self.view];
	self.searchResults = offers;
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
	}
	SearchOffer *offer = ((SearchOffer *)[self.searchResults objectAtIndex:indexPath.row]);
	cell.textLabel.text = offer.Title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ // %@", ((offer.HumanYn) ? NSLocalizedString(@"Offer_IShort_Human", @"Offer_IShort_Human") : NSLocalizedString(@"Offer_IShort_Company", @"Offer_IShort_Company")), [[bSettings sharedbSettings] getOfferDate:offer.PublishDate]];
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
	tvc.searchOffer = ((SearchOffer *)[self.searchResults objectAtIndex:indexPath.row]);
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	searchResults = nil;
	[searchResults release];
	webService = nil;
	[webService release];
	searchTerm = nil;
	[searchTerm release];
	[super viewDidUnload];
}

- (void)dealloc {
	[searchResults release];
	[webService release];
	[searchTerm release];
    [super dealloc];
}

@end

