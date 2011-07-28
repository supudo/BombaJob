//
//  Sync.m
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Sync.h"

@implementation Sync

@synthesize delegate, webService;

#pragma mark -
#pragma mark Init

- (void)startSync {
	if (self.webService == nil)
		self.webService = [[WebService alloc] init];
	[self.webService setDelegate:self];
	[self.webService getCategories];
}

- (void)finishSync {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(syncFinished:)])
		[delegate syncFinished:self];
}

#pragma mark -
#pragma mark Workers

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(syncError:error:)])
		[delegate syncError:self error:errorMessage];
}

- (void)getCategoriesFinished:(id)sender {
	[self.webService getTextContent];
}

- (void)getTextContentFinished:(id)sender {
	[self finishSync];
}

#pragma mark -
#pragma mark System

- (void)dealloc {
	[webService release];
	[super dealloc];
}

@end
