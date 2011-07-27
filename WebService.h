//
//  WebService.h
//  BombaJob
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLReader.h"
#import "dbCategory.h"
#import "dbJobOffer.h"

@protocol WebServiceDelegate <NSObject>
@optional
- (void)serviceError:(id)sender error:(NSString *)errorMessage;
- (void)postJobFinished:(id)sender;
- (void)postMessageFinished:(id)sender;
- (void)getCategoriesFinished:(id)sender;
- (void)getNewJobsFinished:(id)sender;
- (void)getJobsHumanFinished:(id)sender;
- (void)getJobsCompanyFinished:(id)sender;
@end

@interface WebService : NSObject <NSXMLParserDelegate, URLReaderDelegate> {
	id<WebServiceDelegate> delegate;
	URLReader *urlReader;
	NSManagedObjectContext *managedObjectContext;
	NSString *currentElement;
	int OperationID;
	dbCategory *entCategory;
	dbJobOffer *entOffer;
}

@property (assign) id<WebServiceDelegate> delegate;
@property (nonatomic, retain) URLReader *urlReader;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property int OperationID;
@property (nonatomic, retain) dbCategory *entCategory;
@property (nonatomic, retain) dbJobOffer *entOffer;

typedef enum NLServiceOperations {
	NLOperationPostJob = 0,
	NLOperationPostMessage,
	NLOperationGetCategories,
	NLOperationGetNewJobs,
	NLOperationGetJobsHuman,
	NLOperationGetJobsCompany
} NLServiceOperations;

- (void)postNewJob;
- (void)postMessage:(int)offerID message:(NSString *)msg;
- (void)getCategories;
- (void)getNewJobs;
- (void)searchJobs;
- (void)searchPeople;

@end