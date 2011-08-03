//
//  SearchJobs.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface SearchJobs : UITableViewController <WebServiceDelegate, NSFetchedResultsControllerDelegate> {
	WebService *webService;
	NSFetchedResultsController *fetchedResultsControllerOffers, *fetchedResultsControllerCategories;
}

@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsControllerOffers, *fetchedResultsControllerCategories;

- (void)loadData;
- (void)reloadContent;

@end
