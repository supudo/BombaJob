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
	self.navigationItem.title = NSLocalizedString(@"NewOffersNew", @"NewOffersNew");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	//[self designToolbar];
	if (webService == nil)
		webService = [[WebService alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	[self loadData];
}

- (void)loadData {
	if ([[bSettings sharedbSettings] connectedToInternet]) {
		if (![bSettings sharedbSettings].doSync || [bSettings sharedbSettings].sdlNewJobs)
			[self getNewJobsFinished:nil];
		else {
			[webService setDelegate:self];
			[webService getNewJobs:FALSE];
		}
	}
	else
		[self getNewJobsFinished:nil];
}

- (void)designToolbar {
	UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 44.01)];
	tools.barStyle = -1;
	tools.clearsContextBeforeDrawing = NO;
	tools.clipsToBounds = NO;
	tools.tintColor = [UIColor clearColor];
	
	NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
	
	UIBarButtonItem *bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postOffer)];
	bi.style = UIBarButtonItemStyleBordered;
	[buttons addObject:bi];
	
	bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[buttons addObject:bi];
	
	bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadContent)];
	bi.style = UIBarButtonItemStyleBordered;
	[buttons addObject:bi];
	
	[tools setItems:buttons animated:NO];
	
	UIBarButtonItem *rightButtonBar = [[UIBarButtonItem alloc] initWithCustomView:tools];
	self.navigationItem.rightBarButtonItem = rightButtonBar;
}

- (void)reloadContent {
	[[bSettings sharedbSettings] startLoading:self.view];
	[bSettings sharedbSettings].sdlNewJobs = FALSE;
	[webService setDelegate:self];
	[webService getNewJobs:FALSE];
}

- (void)postOffer {
	[appDelegate.tabBarController setSelectedIndex:4];
}

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[self contentRefreshed];
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", NSLocalizedString(@"NewJobsError", @"NewJobsError")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
	alert.tag = 1;
	[alert show];
}

- (void)getNewJobsFinished:(id)sender {
	[self contentRefreshed];
	[[bSettings sharedbSettings] stopLoading:self.view];
	[bSettings sharedbSettings].sdlNewJobs = TRUE;

	UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:0];
	tb.badgeValue = [NSString stringWithFormat:@"%i", [[DBManagedObjectContext sharedDBManagedObjectContext] getEntitiesCount:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"ReadYn = 0"]]];

	tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:1];
	tb.badgeValue = [NSString stringWithFormat:@"%i", [[DBManagedObjectContext sharedDBManagedObjectContext] getEntitiesCount:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 0 AND ReadYn = 0"]]];
	[bSettings sharedbSettings].sdlJobs = TRUE;

	tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:2];
	tb.badgeValue = [NSString stringWithFormat:@"%i", [[DBManagedObjectContext sharedDBManagedObjectContext] getEntitiesCount:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 1 AND ReadYn = 0"]]];
	[bSettings sharedbSettings].sdlPeople = TRUE;

	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		[[bSettings sharedbSettings] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
		abort();
	}
	[self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
	}
	dbJobOffer *ento = ((dbJobOffer *)[fetchedResultsController objectAtIndexPath:indexPath]);
	//cell.imageView.image = (([ento.SentMessageYn boolValue]) ? [UIImage imageNamed:@"message-sent.png"] : nil);
    cell.imageView.image = (([ento.HumanYn boolValue]) ? [UIImage imageNamed:@"icon_person.png"] : [UIImage imageNamed:@"icon_company.png"]);
	cell.textLabel.text = ento.Title;
	if (![ento.ReadYn boolValue])
		[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14.0]];
	else
		[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
	cell.detailTextLabel.text = [[bSettings sharedbSettings] getOfferDate:ento.PublishDate];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
	tvc.entOffer = (dbJobOffer *)[fetchedResultsController objectAtIndexPath:indexPath];
	[[self navigationController] pushViewController:tvc animated:YES];
}

- (void)refresh {
	[self performSelector:@selector(reloadContent) withObject:nil afterDelay:2.0];
}

- (void)contentRefreshed {
	[self.tableView reloadData];
    [self stopLoading];
}

#pragma mark -
#pragma mark Fetch controllers

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

        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dbManagedObjectContext managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;

    }
	return fetchedResultsController;
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
	webService = nil;
	fetchedResultsController = nil;
    [super viewDidUnload];
}


@end
