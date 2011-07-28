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
@synthesize entCategory, entOffer, entTextContent;

#pragma mark -
#pragma mark Services

- (void)postNewJob {
	self.OperationID = NLOperationPostJob;
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"postNewJob URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postNewJob"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	
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
	
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postNewJob"] postData:postData postMethod:@"POST"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"postNewJob response = %@", xmlData]];
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
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"postMessage URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postMessage"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];

	NSMutableString *postData = [[NSMutableString alloc] init];
	[postData setString:@""];
	[postData appendFormat:@"oid=%i", offerID];
	[postData appendFormat:@"&message=%@", msg];

	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=postMessage"] postData:postData postMethod:@"POST"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"postMessage response = %@", xmlData]];
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

- (void)getCategories {
	self.OperationID = NLOperationGetCategories;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"Category"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"getCategories URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getCategories"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getCategories"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"getCategories response = %@", xmlData]];
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

- (void)getNewJobs {
	self.OperationID = NLOperationGetNewJobs;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"JobOffer"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"getNewJobs URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getNewJobs"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getNewJobs"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"getNewJobs response = %@", xmlData]];
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

- (void)searchJobs {
	self.OperationID = NLOperationGetJobsHuman;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteObjects:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 0"]];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"searchJobs URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchJobs"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchJobs"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"searchJobs response = %@", xmlData]];
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

- (void)searchPeople {
	self.OperationID = NLOperationGetJobsCompany;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteObjects:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 1"]];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"searchPeople URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchPeople"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=searchPeople"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"searchPeople response = %@", xmlData]];
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
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"getTextContent URL call = %@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getTextContent"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [bSettings sharedbSettings].ServicesURL, @"action=getTextContent"] postData:@"" postMethod:@"GET"];
	[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"getTextContent response = %@", xmlData]];
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
		entCategory = (dbCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:managedObjectContext];
		[entCategory setCategoryID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
		[entCategory setOffersCount:[NSNumber numberWithInt:[[attributeDict objectForKey:@"cnt"] intValue]]];
	}
	else if ([elementName isEqualToString:@"job"]) {
		entOffer = (dbJobOffer *)[NSEntityDescription insertNewObjectForEntityForName:@"JobOffer" inManagedObjectContext:managedObjectContext];
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
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
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
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (self.OperationID != NLOperationPostJob && self.OperationID != NLOperationPostMessage) {
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
	[super dealloc];
}

@end