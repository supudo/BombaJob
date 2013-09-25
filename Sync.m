//
//  Sync.m
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Sync.h"

@implementation Sync

@synthesize delegate, webService, doFullSync, xmlErrorOccured;

#pragma mark -
#pragma mark Init

- (void)startSync:(BOOL)fullSync {
    self.doFullSync = fullSync;
    self.xmlErrorOccured = FALSE;
	if (webService == nil)
		webService = [[WebService alloc] init];
	[webService setDelegate:self];
	[webService getConfiguration];
}

- (void)finishSync {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(syncFinished:)])
		[delegate syncFinished:self];
}

#pragma mark -
#pragma mark Workers

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
    self.xmlErrorOccured = TRUE;
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(syncError:error:)])
		[delegate syncError:self error:errorMessage];
}

- (void)configFinshed:(id)sender {
    if (!self.xmlErrorOccured)
        [self.webService getCategories:doFullSync];
}

- (void)getCategoriesFinished:(id)sender {
    if (!self.xmlErrorOccured)
        [self.webService getTextContent];
}

- (void)getTextContentFinished:(id)sender {
    if (!self.xmlErrorOccured)
        [self finishSync];
}

#pragma mark -
#pragma mark System


@end
