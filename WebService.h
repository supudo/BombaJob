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
#import "dbSettings.h"

@protocol WebServiceDelegate <NSObject>
@optional
- (void)serviceError:(id)sender error:(NSString *)errorMessage;
- (void)tokenSent:(id)sender;
- (void)postJobFinished:(id)sender;
- (void)postMessageFinished:(id)sender;
- (void)getCategoriesFinished:(id)sender;
- (void)getNewJobsFinished:(id)sender;
- (void)getJobsHumanFinished:(id)sender;
- (void)getJobsCompanyFinished:(id)sender;
- (void)getTextContentFinished:(id)sender;
- (void)searchOffersFinished:(id)sender results:(NSMutableArray *)offers;
- (void)geoSearchOffersFinished:(id)sender results:(NSMutableArray *)offers;
- (void)sendEmailMessageFinished:(id)sender;
- (void)configFinshed:(id)sender;
@end

@interface WebService : NSObject <NSXMLParserDelegate, URLReaderDelegate> {
	id<WebServiceDelegate> __weak delegate;
	URLReader *urlReader;
	NSManagedObjectContext *managedObjectContext;
	NSString *currentElement;
	int OperationID;
	dbCategory *entCategory;
	dbJobOffer *entOffer;
	dbTextContent *entTextContent;
	NSMutableArray *searchResults;
	SearchOffer *searchSingle;
    dbSettings *entSetting;
}

@property (weak) id<WebServiceDelegate> delegate;
@property (nonatomic, strong) URLReader *urlReader;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property int OperationID;
@property (nonatomic, strong) dbCategory *entCategory;
@property (nonatomic, strong) dbJobOffer *entOffer;
@property (nonatomic, strong) dbTextContent *entTextContent;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) SearchOffer *searchSingle;
@property (nonatomic, strong) dbSettings *entSetting;

typedef enum NLServiceOperations {
    NLOperationAPNS = 0,
	NLOperationPostJob,
	NLOperationPostMessage,
	NLOperationGetCategories,
	NLOperationGetNewJobs,
	NLOperationGetJobsHuman,
	NLOperationGetJobsCompany,
	NLOperationGetTextContents,
	NLOperationSearch,
	NLOperationSearchGeo,
	NLOperationSendEmail,
	NLOperationConfigs
} NLServiceOperations;

- (void)sendDeviceToken:(NSData *)token;
- (void)getConfiguration;
- (void)postNewJob;
- (void)postMessage:(int)offerID message:(NSString *)msg;
- (void)getCategories:(BOOL)doFullSync;
- (void)getNewJobs:(BOOL)doFullSync;
- (void)searchJobs:(BOOL)doFullSync;
- (void)searchPeople:(BOOL)doFullSync;
- (void)getTextContent;
- (void)searchOffers:(NSString *)searchTerm freelance:(BOOL)frl;
- (void)geoSearchOffers:(NSString *)searchTerm freelance:(BOOL)frl latitude:(float)lat longitude:(float)lon;
- (void)sendEmailMessage:(int)offerID toEmail:(NSString *)toEmail fromEmail:(NSString *)fromEmail;

@end