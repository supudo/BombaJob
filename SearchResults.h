//
//  SearchResults.h
//  BombaJob
//
//  Created by supudo on 8/2/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface SearchResults : UITableViewController <WebServiceDelegate, NSFetchedResultsControllerDelegate> {
	WebService *webService;
	NSString *searchTerm;
	BOOL freelanceOn, searchOffline;
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSString *searchTerm;
@property BOOL freelanceOn, searchOffline;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)reloadContent;

@end
