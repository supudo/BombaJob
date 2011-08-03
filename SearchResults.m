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
#import "DBManagedObjectContext.h"

static NSString *kCellIdentifier = @"identifSearchResults";

@implementation SearchResults

@synthesize searchResults, webService, searchTerm, freelanceOn, fetchedResultsController;

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

	if ([bSettings sharedbSettings].stOnlineSearch) {
		if (self.searchResults == nil)
			self.searchResults = [[NSMutableArray alloc] init];
		[self.searchResults removeAllObjects];

		if (self.webService == nil)
			self.webService = [[WebService alloc] init];
		[self.webService setDelegate:self];
		[self.webService searchOffers:self.searchTerm freelance:freelanceOn];
	}
	else {
		[[bSettings sharedbSettings] stopLoading:self.view];
		NSError *error = nil;
		if (![[self fetchedResultsController] performFetch:&error]) {
			[[bSettings sharedbSettings] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
			abort();
		}
		[self.tableView reloadData];
	}
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
	if ([bSettings sharedbSettings].stOnlineSearch)
		return [searchResults count];
	else {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}
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
	if ([bSettings sharedbSettings].stOnlineSearch) {
		SearchOffer *offer = ((SearchOffer *)[self.searchResults objectAtIndex:indexPath.row]);
		cell.textLabel.text = offer.Title;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ // %@", ((offer.HumanYn) ? NSLocalizedString(@"Offer_IShort_Human", @"Offer_IShort_Human") : NSLocalizedString(@"Offer_IShort_Company", @"Offer_IShort_Company")), [[bSettings sharedbSettings] getOfferDate:offer.PublishDate]];
	}
	else {
		dbJobOffer *ento = ((dbJobOffer *)[fetchedResultsController objectAtIndexPath:indexPath]);
		cell.textLabel.text = ento.Title;
		cell.detailTextLabel.text = [[bSettings sharedbSettings] getOfferDate:ento.PublishDate];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
	if ([bSettings sharedbSettings].stOnlineSearch)
		tvc.searchOffer = ((SearchOffer *)[self.searchResults objectAtIndex:indexPath.row]);
	else
		tvc.entOffer = (dbJobOffer *)[fetchedResultsController objectAtIndexPath:indexPath];
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

#pragma mark -
#pragma mark DB

- (NSFetchedResultsController *)fetchedResultsController {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"JobOffer" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PublishDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Title CONTAINS[cd] %@\
								  OR Positivism CONTAINS[cd] %@\
								  OR Negativism CONTAINS[cd] %@", self.searchTerm, self.searchTerm, self.searchTerm];
		[fetchRequest setPredicate:predicate];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dbManagedObjectContext managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	return fetchedResultsController;
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
	fetchedResultsController = nil;
	[fetchedResultsController release];
	[super viewDidUnload];
}

- (void)dealloc {
	[searchResults release];
	[webService release];
	[searchTerm release];
	[fetchedResultsController release];
    [super dealloc];
}

@end

