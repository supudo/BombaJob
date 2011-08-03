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
}

@property (nonatomic, retain) Sync *syncer;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) IBOutlet UILabel *lblSync;

- (void)loadSync;
- (void)finishSync;
- (void)startSync;
- (void)startSyncTimer;

@end
