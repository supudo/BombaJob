//
//  SyncAgain.h
//  BombaJob
//
//  Created by supudo on 8/3/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sync.h"

@interface SyncAgain : UIViewController <SyncDelegate> {
	Sync *syncer;
	NSTimer *timer;
	UILabel *lblSync;
	BOOL doFullSync;
}

@property (nonatomic, strong) Sync *syncer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) IBOutlet UILabel *lblSync;
@property BOOL doFullSync;

- (void)loadSync;
- (void)finishSync;
- (void)startSync;
- (void)startSyncTimer;

@end
