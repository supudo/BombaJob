//
//  CategoriesOffers.h
//  BombaJob
//
//  Created by supudo on 8/3/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbCategory.h"
#import "BMTableView.h"

@interface CategoriesOffers : BMTableView <NSFetchedResultsControllerDelegate> {
	dbCategory *entCategory;
	NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) dbCategory *entCategory;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)postOffer;

@end
