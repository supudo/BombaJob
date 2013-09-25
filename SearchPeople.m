//
//  SearchPeople.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "SearchPeople.h"
#import "BlackAlertView.h"
#import "DBManagedObjectContext.h"
#import "Offer.h"
#import "CategoriesOffers.h"

static NSString *kCellIdentifier = @"identifJobsPeople";
static NSString *kCellIdentifierCategory = @"identifCategoriesPeople";

@implementation SearchPeople

@synthesize webService, fetchedResultsControllerOffers, fetchedResultsControllerCategories, viewCategories, viewOffers;

#pragma mark -
#pragma mark Workers

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"People", @"People");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	//self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadContent)] autorelease];
	//[self designToolbar];
	if (self.webService == nil)
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
		if (![bSettings sharedbSettings].doSync || [bSettings sharedbSettings].sdlPeople)
			[self getJobsCompanyFinished:nil];
		else {
			[webService setDelegate:self];
			[webService searchPeople:FALSE];
		}
	}
	else
		[self getJobsCompanyFinished:nil];
}

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[self contentRefreshed];
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", NSLocalizedString(@"NewJobsError", @"NewJobsError")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
	alert.tag = 1;
	[alert show];
}

- (void)getJobsCompanyFinished:(id)sender {
	[self contentRefreshed];
	[[bSettings sharedbSettings] stopLoading:self.view];
	[bSettings sharedbSettings].sdlPeople = TRUE;
	UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:2];
	tb.badgeValue = [NSString stringWithFormat:@"%i", [[DBManagedObjectContext sharedDBManagedObjectContext] getEntitiesCount:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 1 AND ReadYn = 0"]]];
	NSError *error = nil;
	if (![[self fetchedResultsControllerOffers] performFetch:&error] || ![[self fetchedResultsControllerCategories] performFetch:&error]) {
		[[bSettings sharedbSettings] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
		abort();
	}
	[self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
	[bSettings sharedbSettings].sdlPeople = FALSE;
	[webService setDelegate:self];
	[webService searchPeople:FALSE];
}

- (void)postOffer {
	[appDelegate.tabBarController setSelectedIndex:4];
}

#pragma mark -
#pragma mark Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([bSettings sharedbSettings].stShowCategories)
		return 2;
	else
		return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([bSettings sharedbSettings].stShowCategories) {
		if (section == 0)
			return [[fetchedResultsControllerCategories fetchedObjects] count];
		else
			return [[fetchedResultsControllerOffers fetchedObjects] count];
	}
	else
		return [[fetchedResultsControllerOffers fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	if ([bSettings sharedbSettings].stShowCategories) {
		if (indexPath.section == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierCategory];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifierCategory];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleGray;
				cell.textLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
				cell.detailTextLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
			}
			dbCategory *ento = ((dbCategory *)[fetchedResultsControllerCategories objectAtIndexPath:indexPath]);
			cell.textLabel.text = ento.CategoryTitle;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %i", NSLocalizedString(@"OffersCount", @"OffersCount"), [ento.OffersCount intValue]];
		}
		else {
			cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleGray;
				cell.textLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
				cell.detailTextLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
			}
			dbJobOffer *ento = ((dbJobOffer *)[fetchedResultsControllerOffers objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]]);
			cell.imageView.image = (([ento.SentMessageYn boolValue]) ? [UIImage imageNamed:@"message-sent.png"] : nil);
			cell.textLabel.text = ento.Title;
			if (![ento.ReadYn boolValue])
				[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14.0]];
			else
				[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
			cell.detailTextLabel.text = [[bSettings sharedbSettings] getOfferDate:ento.PublishDate];
		}
	}
	else {
		cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleGray;
			cell.textLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
			cell.detailTextLabel.font = [UIFont fontWithName:@"Ubuntu" size:14.0];
		}
		dbJobOffer *ento = ((dbJobOffer *)[fetchedResultsControllerOffers objectAtIndexPath:indexPath]);
		cell.imageView.image = (([ento.SentMessageYn boolValue]) ? [UIImage imageNamed:@"message-sent.png"] : nil);
		cell.textLabel.text = ento.Title;
		if (![ento.ReadYn boolValue])
			[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14.0]];
		else
			[cell.textLabel setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
		cell.detailTextLabel.text = [[bSettings sharedbSettings] getOfferDate:ento.PublishDate];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([bSettings sharedbSettings].stShowCategories) {
		if (indexPath.section == 0) {
			CategoriesOffers *tvc = [[CategoriesOffers alloc] initWithNibName:@"CategoriesOffers" bundle:nil];
			tvc.entCategory = (dbCategory *)[fetchedResultsControllerCategories objectAtIndexPath:indexPath];
			[[self navigationController] pushViewController:tvc animated:YES];
		}
		else {
			Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
			tvc.entOffer = (dbJobOffer *)[fetchedResultsControllerOffers objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
			[[self navigationController] pushViewController:tvc animated:YES];
		}
	}
	else {
		Offer *tvc = [[Offer alloc] initWithNibName:@"Offer" bundle:nil];
		tvc.entOffer = (dbJobOffer *)[fetchedResultsControllerOffers objectAtIndexPath:indexPath];
		[[self navigationController] pushViewController:tvc animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([bSettings sharedbSettings].stShowCategories)
		return 44.0;
	else
		return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if ([bSettings sharedbSettings].stShowCategories) {
		UILabel *lbl;
		
		if (viewCategories == nil) {
			viewCategories = [[UIView alloc] init];
			lbl = [[UILabel alloc] init];
			[lbl setText:NSLocalizedString(@"UI.Categories", @"UI.Categories")];
			[lbl setBackgroundColor:[UIColor clearColor]];
			[lbl setTextColor:[UIColor orangeColor]];
			[lbl setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:18.0]];
			[lbl setFrame:CGRectMake(20, 4, 280, 40)];
			[viewCategories addSubview:lbl];
		}
		
		if (viewOffers == nil) {
			viewOffers = [[UIView alloc] init];
			lbl = [[UILabel alloc] init];
			[lbl setText:NSLocalizedString(@"UI.Offers", @"UI.Offers")];
			[lbl setBackgroundColor:[UIColor clearColor]];
			[lbl setTextColor:[UIColor orangeColor]];
			[lbl setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:18.0]];
			[lbl setFrame:CGRectMake(20, 0, 280, 40)];
			[viewOffers addSubview:lbl];
		}
		
		if (section == 0)
			return viewCategories;
		else
			return viewOffers;
	}
	else
		return nil;
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

- (NSFetchedResultsController *)fetchedResultsControllerCategories {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	
    if (fetchedResultsControllerCategories == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CategoryTitle" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"OffersCount > 0"];
		[fetchRequest setPredicate:predicate];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dbManagedObjectContext managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsControllerCategories = aFetchedResultsController;
        
    }
	return fetchedResultsControllerCategories;
}

- (NSFetchedResultsController *)fetchedResultsControllerOffers {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	
    if (fetchedResultsControllerOffers == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"JobOffer" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptorRead = [[NSSortDescriptor alloc] initWithKey:@"ReadYn" ascending:YES];
        NSSortDescriptor *sortDescriptorDate = [[NSSortDescriptor alloc] initWithKey:@"PublishDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorRead, sortDescriptorDate, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"HumanYn = 1"];
		[fetchRequest setPredicate:predicate];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dbManagedObjectContext managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsControllerOffers = aFetchedResultsController;
        
    }
	return fetchedResultsControllerOffers;
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
	fetchedResultsControllerOffers = nil;
	fetchedResultsControllerCategories = nil;
	viewCategories = nil;
	viewOffers = nil;
    [super viewDidUnload];
}


@end
