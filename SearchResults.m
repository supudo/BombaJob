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

@synthesize webService, searchTerm, freelanceOn, searchOffline, fetchedResultsController;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Search", @"Search");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadContent)] autorelease];
	[self reloadContent];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)reloadContent {
	[[bSettings sharedbSettings] startLoading:self.view];

	if ([bSettings sharedbSettings].stOnlineSearch && !self.searchOffline) {
		[[bSettings sharedbSettings].latestSearchResults removeAllObjects];

		if (self.webService == nil)
			self.webService = [[WebService alloc] init];
		[webService setDelegate:self];
		[webService searchOffers:self.searchTerm freelance:freelanceOn];
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
	[bSettings sharedbSettings].latestSearchResults = offers;
	UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:3];
	tb.badgeValue = [NSString stringWithFormat:@"%i", [[bSettings sharedbSettings].latestSearchResults count]];
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([bSettings sharedbSettings].stOnlineSearch && !self.searchOffline)
		return [[bSettings sharedbSettings].latestSearchResults count];
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
	if ([bSettings sharedbSettings].stOnlineSearch && !self.searchOffline) {
		SearchOffer *offer = ((SearchOffer *)[[bSettings sharedbSettings].latestSearchResults objectAtIndex:indexPath.row]);
		cell.imageView.image = ((offer.SentMessageYn) ? [UIImage imageNamed:@"message-sent.png"] : nil);
		cell.textLabel.text = offer.Title;
		if (!offer.ReadYn)
			[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14.0]];
		else
			[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ // %@", ((offer.HumanYn) ? NSLocalizedString(@"Offer_IShort_Human", @"Offer_IShort_Human") : NSLocalizedString(@"Offer_IShort_Company", @"Offer_IShort_Company")), [[bSettings sharedbSettings] getOfferDate:offer.PublishDate]];
	}
	else {
		dbJobOffer *ento = ((dbJobOffer *)[fetchedResultsController objectAtIndexPath:indexPath]);
		cell.imageView.image = (([ento.SentMessageYn boolValue]) ? [UIImage imageNamed:@"message-sent.png"] : nil);
		cell.textLabel.text = ento.Title;
		if (![ento.ReadYn boolValue])
			[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14.0]];
		else
			[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ // %@", ((ento.HumanYn) ? NSLocalizedString(@"Offer_IShort_Human", @"Offer_IShort_Human") : NSLocalizedString(@"Offer_IShort_Company", @"Offer_IShort_Company")), [[bSettings sharedbSettings] getOfferDate:ento.PublishDate]];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
	if ([bSettings sharedbSettings].stOnlineSearch && !self.searchOffline)
		tvc.searchOffer = ((SearchOffer *)[[bSettings sharedbSettings].latestSearchResults objectAtIndex:indexPath.row]);
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
        
        NSSortDescriptor *sortDescriptorRead = [[NSSortDescriptor alloc] initWithKey:@"ReadYn" ascending:YES];
        NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc] initWithKey:@"PublishDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorRead, sortDescriptorDate, nil];
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
        [sortDescriptorRead release];
        [sortDescriptorDate release];
        [sortDescriptors release];

		UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:1];
		tb.badgeValue = [NSString stringWithFormat:@"%i", [[[fetchedResultsController sections] objectAtIndex:1] numberOfObjects]];
    }
	return fetchedResultsController;
}

#pragma mark -
#pragma mark Memory management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ? NO : [bSettings sharedbSettings].shouldRotate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	webService = nil;
	[webService release];
	searchTerm = nil;
	[searchTerm release];
	fetchedResultsController = nil;
	[fetchedResultsController release];
	[super viewDidUnload];
}

- (void)dealloc {
	[webService release];
	[searchTerm release];
	[fetchedResultsController release];
    [super dealloc];
}

@end

