//
//  NewestOffers.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "BMTableView.h"

@interface NewestOffers : BMTableView <WebServiceDelegate, NSFetchedResultsControllerDelegate> {
	WebService *webService;
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)loadData;
- (void)reloadContent;
- (void)postOffer;
- (void)designToolbar;
- (void)contentRefreshed;

@end
