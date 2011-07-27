//
//  NewestOffers.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "NewestOffers.h"
#import "BlackAlertView.h"
#import "DBManagedObjectContext.h"
#import "Offer.h"

static NSString *kCellIdentifier = @"identifNewJobs";

@implementation NewestOffers

@synthesize webService, fetchedResultsController;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"NewOffers", @"NewOffers");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadContent)] autorelease];
	if (self.webService == nil)
		webService = [[WebService alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	if (![bSettings sharedbSettings].doSync || [bSettings sharedbSettings].sdlNewJobs)
		[self getNewJobsFinished:nil];
	else {
		[webService setDelegate:self];
		[webService getNewJobs];
	}
}

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", NSLocalizedString(@"NewJobsError", @"NewJobsError")] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	alert.tag = 1;
	[alert show];
	[alert release];
}

- (void)getNewJobsFinished:(id)sender {
	[[bSettings sharedbSettings] stopLoading:self.view];
	[bSettings sharedbSettings].sdlNewJobs = TRUE;
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		[[bSettings sharedbSettings] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
		abort();
	}
	[self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
}

- (void)reloadContent {
	[[bSettings sharedbSettings] startLoading:self.view];
	[bSettings sharedbSettings].sdlNewJobs = FALSE;
	[webService setDelegate:self];
	[webService getNewJobs];
}

#pragma mark -
#pragma mark Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
	dbJobOffer *ento = ((dbJobOffer *)[fetchedResultsController objectAtIndexPath:indexPath]);
	cell.textLabel.text = ento.Title;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ // %@", (([ento.HumanYn boolValue]) ? NSLocalizedString(@"Offer_IShort_Human", @"Offer_IShort_Human") : NSLocalizedString(@"Offer_IShort_Company", @"Offer_IShort_Company")), [[bSettings sharedbSettings] getOfferDate:ento.PublishDate]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
	tvc.entOffer = (dbJobOffer *)[fetchedResultsController objectAtIndexPath:indexPath];
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

- (NSFetchedResultsController *)fetchedResultsController {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

        NSEntityDescription *entity = [NSEntityDescription entityForName:@"JobOffer" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
        [fetchRequest setEntity:entity];

        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"PublishDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];

        [fetchRequest setSortDescriptors:sortDescriptors];

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
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	webService = nil;
	[webService release];
	fetchedResultsController = nil;
	[fetchedResultsController release];
    [super viewDidUnload];
}

- (void)dealloc {
	[webService release];
	[fetchedResultsController release];
    [super dealloc];
}

@end
