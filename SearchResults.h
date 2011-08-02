//
//  SearchResults.h
//  BombaJob
//
//  Created by supudo on 8/2/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface SearchResults : UITableViewController <WebServiceDelegate> {
	NSMutableArray *searchResults;
	WebService *webService;
	NSString *searchTerm;
	BOOL freelanceOn;
}

@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSString *searchTerm;
@property BOOL freelanceOn;

- (void)reloadContent;

@end
