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
#import "dbTextContent.h"
#import "SearchOffer.h"

@protocol WebServiceDelegate <NSObject>
@optional
- (void)serviceError:(id)sender error:(NSString *)errorMessage;
- (void)postJobFinished:(id)sender;
- (void)postMessageFinished:(id)sender;
- (void)getCategoriesFinished:(id)sender;
- (void)getNewJobsFinished:(id)sender;
- (void)getJobsHumanFinished:(id)sender;
- (void)getJobsCompanyFinished:(id)sender;
- (void)getTextContentFinished:(id)sender;
- (void)searchOffersFinished:(id)sender results:(NSMutableArray *)offers;
- (void)sendEmailMessageFinished:(id)sender;
@end

@interface WebService : NSObject <NSXMLParserDelegate, URLReaderDelegate> {
	id<WebServiceDelegate> delegate;
	URLReader *urlReader;
	NSManagedObjectContext *managedObjectContext;
	NSString *currentElement;
	int OperationID;
	dbCategory *entCategory;
	dbJobOffer *entOffer;
	dbTextContent *entTextContent;
	NSMutableArray *searchResults;
	SearchOffer *searchSingle;
}

@property (assign) id<WebServiceDelegate> delegate;
@property (nonatomic, retain) URLReader *urlReader;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property int OperationID;
@property (nonatomic, retain) dbCategory *entCategory;
@property (nonatomic, retain) dbJobOffer *entOffer;
@property (nonatomic, retain) dbTextContent *entTextContent;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) SearchOffer *searchSingle;

typedef enum NLServiceOperations {
	NLOperationPostJob = 0,
	NLOperationPostMessage,
	NLOperationGetCategories,
	NLOperationGetNewJobs,
	NLOperationGetJobsHuman,
	NLOperationGetJobsCompany,
	NLOperationGetTextContents,
	NLOperationSearch,
	NLOperationSendEmail
} NLServiceOperations;

- (void)postNewJob;
- (void)postMessage:(int)offerID message:(NSString *)msg;
- (void)getCategories:(BOOL)doFullSync;
- (void)getNewJobs:(BOOL)doFullSync;
- (void)searchJobs:(BOOL)doFullSync;
- (void)searchPeople:(BOOL)doFullSync;
- (void)getTextContent;
- (void)searchOffers:(NSString *)searchTerm freelance:(BOOL)frl;
- (void)sendEmailMessage:(int)offerID toEmail:(NSString *)toEmail fromEmail:(NSString *)fromEmail;

@end