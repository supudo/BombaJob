//
//  CategoriesOffers.m
//  BombaJob
//
//  Created by supudo on 8/3/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "CategoriesOffers.h"
#import "dbJobOffer.h"
#import "DBManagedObjectContext.h"
#import "Offer.h"

static NSString *kCellIdentifier = @"identifJobsCategories";

@implementation CategoriesOffers

@synthesize entCategory, fetchedResultsController;

#pragma mark -
#pragma mark Workers

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = entCategory.CategoryTitle;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postOffer)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		[[bSettings sharedbSettings] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
		abort();
	}
	[self.tableView reloadData];
}

- (void)postOffer {
	[appDelegate.tabBarController setSelectedIndex:4];
}

#pragma mark -
#pragma mark Delegates

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
	cell.imageView.image = (([ento.SentMessageYn boolValue]) ? [UIImage imageNamed:@"message-sent.png"] : nil);
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
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CategoryID = %i", [entCategory.CategoryID intValue]];
		[fetchRequest setPredicate:predicate];
		
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
	entCategory = nil;
	fetchedResultsController = nil;
	[super viewDidUnload];
}


@end

