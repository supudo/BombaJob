//
//  Sync.h
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebService.h"

@protocol SyncDelegate <NSObject>
@optional
- (void)syncError:(id)sender error:(NSString *)errorMessage;
- (void)syncFinished:(id)sender;
@end

@interface Sync : NSObject <WebServiceDelegate> {
	id<SyncDelegate> __weak delegate;
	WebService *webService;
    BOOL doFullSync, xmlErrorOccured;
}

@property (weak) id<SyncDelegate> delegate;
@property (nonatomic, strong) WebService *webService;
@property BOOL doFullSync, xmlErrorOccured;

- (void)startSync:(BOOL)fullSync;
- (void)finishSync;

@end
