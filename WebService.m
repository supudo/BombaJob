//
//  WebService.m
//  bombajob.bg
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import "WebService.h"
#import "DBManagedObjectContext.h"

@implementation WebService

@synthesize delegate, urlReader, managedObjectContext, OperationID;
@synthesize entCategory, entOffer, entTextContent, searchResults, searchSingle, entSetting;

#pragma mark -
#pragma mark Services

- (void)getConfiguration {
	self.OperationID = NLOperationConfigs;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[bSettings sharedbSettings] LogThis:@"getConfig URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getConfig"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getConfig"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:@"getConfig response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(configFinshed:)])
		[delegate configFinshed:self];
}

- (void)postNewJob {
	self.OperationID = NLOperationPostJob;
	[[bSettings sharedbSettings] LogThis:@"postNewJob URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postNewJob"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	
	NSMutableString *postData = [[NSMutableString alloc] init];
	[postData setString:@""];
	[postData appendFormat:@"oid=0"];
	[postData appendFormat:@"&cid=%i", [bSettings sharedbSettings].currentOffer.CategoryID];
	[postData appendFormat:@"&h=%@", (([bSettings sharedbSettings].currentOffer.HumanYn) ? @"1" : @"0")];
	[postData appendFormat:@"&fr=%@", (([bSettings sharedbSettings].currentOffer.FreelanceYn) ? @"1" : @"0")];
	[postData appendFormat:@"&tt=%@", [bSettings sharedbSettings].currentOffer.Title];
	[postData appendFormat:@"&em=%@", [bSettings sharedbSettings].currentOffer.Email];
	[postData appendFormat:@"&pos=%@", [bSettings sharedbSettings].currentOffer.Positivism];
	[postData appendFormat:@"&neg=%@", [bSettings sharedbSettings].currentOffer.Negativism];
	
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postNewJob"] postData:postData postMethod:@"POST"];
	[[bSettings sharedbSettings] LogThis:@"postNewJob response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(postJobFinished:)])
		[delegate postJobFinished:self];
	
	[postData release];
}

- (void)postMessage:(int)offerID message:(NSString *)msg {
	self.OperationID = NLOperationPostMessage;
	[[bSettings sharedbSettings] LogThis:@"postMessage URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postMessage"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];

	NSMutableString *postData = [[NSMutableString alloc] init];
	[postData setString:@""];
	[postData appendFormat:@"oid=%i", offerID];
	[postData appendFormat:@"&message=%@", msg];

	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postMessage"] postData:postData postMethod:@"POST"];
	[[bSettings sharedbSettings] LogThis:@"postMessage response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(postMessageFinished:)])
		[delegate postMessageFinished:self];

	[postData release];
}

- (void)getCategories:(BOOL)doFullSync {
	self.OperationID = NLOperationGetCategories;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	if (doFullSync)
		[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"Category"];
	[[bSettings sharedbSettings] LogThis:@"getCategories URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getCategories"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getCategories"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:@"getCategories response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getCategoriesFinished:)])
		[delegate getCategoriesFinished:self];
}

- (void)getNewJobs:(BOOL)doFullSync {
	self.OperationID = NLOperationGetNewJobs;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	if (doFullSync)
		[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"JobOffer"];
	[[bSettings sharedbSettings] LogThis:@"getNewJobs URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getNewJobs"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getNewJobs"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:@"getNewJobs response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getNewJobsFinished:)])
		[delegate getNewJobsFinished:self];
}

- (void)searchJobs:(BOOL)doFullSync {
	self.OperationID = NLOperationGetJobsHuman;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	if (doFullSync)
		[[DBManagedObjectContext sharedDBManagedObjectContext] deleteObjects:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 0"]];
	[[bSettings sharedbSettings] LogThis:@"searchJobs URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchJobs"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchJobs"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:@"searchJobs response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getJobsHumanFinished:)])
		[delegate getJobsHumanFinished:self];
}

- (void)searchPeople:(BOOL)doFullSync {
	self.OperationID = NLOperationGetJobsCompany;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	if (doFullSync)
		[[DBManagedObjectContext sharedDBManagedObjectContext] deleteObjects:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 1"]];
	[[bSettings sharedbSettings] LogThis:@"searchPeople URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchPeople"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchPeople"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:@"searchPeople response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getJobsCompanyFinished:)])
		[delegate getJobsCompanyFinished:self];
}

- (void)getTextContent {
	self.OperationID = NLOperationGetTextContents;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"TextContent"];
	[[bSettings sharedbSettings] LogThis:@"getTextContent URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getTextContent"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getTextContent"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:@"getTextContent response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getTextContentFinished:)])
		[delegate getTextContentFinished:self];
}

- (void)sendEmailMessage:(int)offerID toEmail:(NSString *)toEmail fromEmail:(NSString *)fromEmail {
	self.OperationID = NLOperationSendEmail;
	[[bSettings sharedbSettings] LogThis:@"sendEmailMessage URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=sendEmailMessage"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	
	NSMutableString *postData = [[NSMutableString alloc] init];
	[postData setString:@""];
	[postData appendFormat:@"oid=%i", offerID];
	[postData appendFormat:@"&toemail=%@", toEmail];
	[postData appendFormat:@"&fromemail=%@", fromEmail];
	
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=sendEmailMessage"] postData:postData postMethod:@"POST"];
	[[bSettings sharedbSettings] LogThis:@"sendEmailMessage response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(sendEmailMessageFinished:)])
		[delegate sendEmailMessageFinished:self];
	
	[postData release];
}

- (void)searchOffers:(NSString *)searchTerm freelance:(BOOL)frl {
	self.OperationID = NLOperationSearch;
	[[bSettings sharedbSettings] LogThis:@"searchOffers URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchOffers"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	
	NSMutableString *postData = [[NSMutableString alloc] init];
	[postData setString:@""];
	[postData appendFormat:@"keyword=%@", searchTerm];
	[postData appendFormat:@"&freelance=%@", ((frl) ? @"true" : @"false")];
	
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchOffers"] postData:postData postMethod:@"POST"];
	[[bSettings sharedbSettings] LogThis:@"searchOffers response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(searchOffersFinished:results:)])
		[delegate searchOffersFinished:self results:searchResults];

	[postData release];
}

- (void)geoSearchOffers:(NSString *)searchTerm freelance:(BOOL)frl latitude:(float)lat longitude:(float)lon {
	self.OperationID = NLOperationSearchGeo;
	[[bSettings sharedbSettings] LogThis:@"geoSearchOffers URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=geoSearchOffers"];
	if (urlReader == nil)
		urlReader = [[URLReader alloc] init];
	[urlReader setDelegate:self];
	
	NSMutableString *postData = [[NSMutableString alloc] init];
	[postData setString:@""];
	[postData appendFormat:@"keyword=%@", searchTerm];
	[postData appendFormat:@"&freelance=%@", ((frl) ? @"true" : @"false")];
	[postData appendFormat:@"&x=%1.6f", lat];
	[postData appendFormat:@"&y=%1.6f", lon];
	
	NSString *xmlData = [urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=geoSearchOffers"] postData:postData postMethod:@"POST"];
	[[bSettings sharedbSettings] LogThis:@"geoSearchOffers response = %@", xmlData];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(geoSearchOffersFinished:results:)])
		[delegate geoSearchOffersFinished:self results:searchResults];
	
	[postData release];
}

#pragma mark -
#pragma mark Events

- (void)urlRequestError:(id)sender errorMessage:(NSString *)errorMessage {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(serviceError:error:)])
		[delegate serviceError:self error:errorMessage];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(serviceError:error:)])
		[delegate serviceError:self error:[parseError localizedDescription]];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = elementName;
	if ([elementName isEqualToString:@"cat"]) {
		entCategory = (dbCategory *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"Category" predicateString:[NSString stringWithFormat:@"CategoryID = %@", [attributeDict objectForKey:@"id"]]];
		if (entCategory == nil)
			entCategory = (dbCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectContext];
		[entCategory setCategoryID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
		[entCategory setOffersCount:[NSNumber numberWithInt:[[attributeDict objectForKey:@"cnt"] intValue]]];
	}
	else if ([elementName isEqualToString:@"job"]) {
		entOffer = (dbJobOffer *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"JobOffer" predicateString:[NSString stringWithFormat:@"OfferID = %@", [attributeDict objectForKey:@"id"]]];
		if (entOffer == nil) {
			entOffer = (dbJobOffer *)[NSEntityDescription insertNewObjectForEntityForName:@"JobOffer" inManagedObjectContext:managedObjectContext];
			[entOffer setReadYn:[NSNumber numberWithInt:0]];
			[entOffer setSentMessageYn:[NSNumber numberWithInt:0]];
		}
		[entOffer setOfferID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
		[entOffer setCategoryID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"cid"] intValue]]];
		[entOffer setHumanYn:[NSNumber numberWithInt:[[attributeDict objectForKey:@"hm"] intValue]]];
		dbCategory *tc = (dbCategory *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"Category" predicateString:[NSString stringWithFormat:@"CategoryID = %@", [attributeDict objectForKey:@"cid"]]];
		[entOffer setCategory:tc];
	}
	else if ([elementName isEqualToString:@"tctxt"]) {
		entTextContent = (dbTextContent *)[NSEntityDescription insertNewObjectForEntityForName:@"TextContent" inManagedObjectContext:managedObjectContext];
		[entTextContent setCID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
	}
	else if ([elementName isEqualToString:@"sores"]) {
		searchSingle = [[SearchOffer alloc] init];
		searchSingle.OfferID = [[attributeDict objectForKey:@"id"] intValue];
		searchSingle.CategoryID = [[attributeDict objectForKey:@"cid"] intValue];
		searchSingle.HumanYn = [[attributeDict objectForKey:@"hm"] boolValue];
		searchSingle.gLatitude = [[attributeDict objectForKey:@"glat"] floatValue];
		searchSingle.gLongitude = [[attributeDict objectForKey:@"glong"] floatValue];
		searchSingle.ReadYn = NO;
		searchSingle.SentMessageYn = NO;
	}
	else if ([elementName isEqualToString:@"getConfig"]) {
        NSString *sVersion = [attributeDict objectForKey:@"version"];
        BOOL sShowBanners = [[attributeDict objectForKey:@"showBanners"] boolValue];
        [bSettings sharedbSettings].NewAppVersion = sVersion;
        [bSettings sharedbSettings].stShowBanners = sShowBanners;

        entSetting = (dbSettings *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"NewAppVersion"]];
		if (entSetting != nil && ![entSetting.SValue isEqualToString:@""])
			entSetting.SValue = sVersion;
		else {
			entSetting = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:managedObjectContext];
			[entSetting setSName:@"NewAppVersion"];
			[entSetting setSValue:sVersion];
		}
        
        entSetting = (dbSettings *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"ShowBanners"]];
		if (entSetting != nil && ![entSetting.SValue isEqualToString:@""])
			entSetting.SValue = ((sShowBanners) ? @"TRUE" : @"FALSE");
		else {
			entSetting = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:managedObjectContext];
			[entSetting setSName:@"ShowBanners"];
			[entSetting setSValue:@"TRUE"];
		}
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	if ([elementName isEqualToString:@"sores"]) {
		if (searchResults == nil)
			searchResults = [[NSMutableArray alloc] init];
		[searchResults addObject:searchSingle];
		[searchSingle release];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
		// Categories
		if ([currentElement isEqualToString:@"cttl"])
			[entCategory setCategoryTitle:string];
		// Job offers
		else if ([currentElement isEqualToString:@"jottl"])
			[entOffer setTitle:string];
		else if ([currentElement isEqualToString:@"jocat"])
			[entOffer setCategoryTitle:string];
		else if ([currentElement isEqualToString:@"jopos"])
			[entOffer setPositivism:string];
		else if ([currentElement isEqualToString:@"joneg"])
			[entOffer setNegativism:string];
		else if ([currentElement isEqualToString:@"joem"])
			[entOffer setEmail:string];
		else if ([currentElement isEqualToString:@"jodt"]) {
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"dd-mm-yyyy HH:mm:ss"];
			[entOffer setPublishDate:[df dateFromString:string]];
			[df release];
		}
		// Post new job offer
		else if ([currentElement isEqualToString:@"postNewJob"]) {
			[bSettings sharedbSettings].currentPostOfferResult = [string boolValue];
			[bSettings sharedbSettings].currentPostOfferResponse = string;
		}
		// Text content
		else if ([currentElement isEqualToString:@"tctitle"])
			[entTextContent setTitle:string];
		else if ([currentElement isEqualToString:@"tccontent"])
			[entTextContent setContent:string];
		// Search
		else if ([currentElement isEqualToString:@"sottl"])
			searchSingle.Title = string;
		else if ([currentElement isEqualToString:@"socat"])
			searchSingle.CategoryTitle = string;
		else if ([currentElement isEqualToString:@"sopos"])
			searchSingle.Positivism = string;
		else if ([currentElement isEqualToString:@"soneg"])
			searchSingle.Negativism = string;
		else if ([currentElement isEqualToString:@"soem"])
			searchSingle.Email = string;
		else if ([currentElement isEqualToString:@"sodt"]) {
			NSDateFormatter *df = [[NSDateFormatter alloc] init];
			[df setDateFormat:@"dd-mm-yyyy HH:mm:ss"];
			searchSingle.PublishDate = [df dateFromString:string];
			[df release];
		}
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (self.OperationID != NLOperationPostJob &&
		self.OperationID != NLOperationPostMessage &&
		self.OperationID != NLOperationSearch &&
		self.OperationID != NLOperationSearchGeo &&
		self.OperationID != NLOperationSendEmail) {
		NSError *error = nil;
		if (![managedObjectContext save:&error])
			abort();
	}
	switch (self.OperationID) {
		case NLOperationPostJob: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(postJobFinished:)])
				[delegate postJobFinished:self];
			break;
		}
		case NLOperationPostMessage: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(postMessageFinished:)])
				[delegate postMessageFinished:self];
			break;
		}
		case NLOperationGetCategories: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getCategoriesFinished:)])
				[delegate getCategoriesFinished:self];
			break;
		}
		case NLOperationGetNewJobs: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getNewJobsFinished:)])
				[delegate getNewJobsFinished:self];
			break;
		}
		case NLOperationGetJobsHuman: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getJobsHumanFinished:)])
				[delegate getJobsHumanFinished:self];
			break;
		}
		case NLOperationGetJobsCompany: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getJobsCompanyFinished:)])
				[delegate getJobsCompanyFinished:self];
			break;
		}
		case NLOperationGetTextContents: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getTextContentFinished:)])
				[delegate getTextContentFinished:self];
			break;
		}
		case NLOperationSearch: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(searchOffersFinished:results:)])
				[delegate searchOffersFinished:self results:searchResults];
			break;
		}
		case NLOperationSearchGeo: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(geoSearchOffersFinished:results:)])
				[delegate geoSearchOffersFinished:self results:searchResults];
			break;
		}
		case NLOperationSendEmail: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(sendEmailMessageFinished:)])
				[delegate sendEmailMessageFinished:self];
			break;
		}
		case NLOperationConfigs: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(configFinshed:)])
				[delegate configFinshed:self];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[currentElement release];
	[managedObjectContext release];
	[entCategory release];
	[entOffer release];
	[entTextContent release];
	[searchResults release];
	[searchSingle release];
    [entSetting release];
	[super dealloc];
}

@end