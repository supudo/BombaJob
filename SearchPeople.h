//
//  SearchPeople.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "BMTableView.h"

@interface SearchPeople : BMTableView <WebServiceDelegate, NSFetchedResultsControllerDelegate> {
	WebService *webService;
	NSFetchedResultsController *fetchedResultsControllerOffers, *fetchedResultsControllerCategories;
	UIView *viewCategories, *viewOffers;
}

@property (nonatomic, strong) WebService *webService;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerOffers, *fetchedResultsControllerCategories;
@property (nonatomic, strong) UIView *viewCategories, *viewOffers;

- (void)loadData;
- (void)reloadContent;
- (void)postOffer;
- (void)designToolbar;
- (void)contentRefreshed;

@end
