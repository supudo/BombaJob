//
//  Loading.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sync.h"

@interface Loading : UIViewController <SyncDelegate> {
	Sync *syncer;
	NSTimer *timer;
	UILabel *lblLoading;
}

@property (nonatomic, strong) Sync *syncer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) IBOutlet UILabel *lblLoading;

- (void)loadSync;
- (void)startSync;
- (void)startSyncTimer;

@end
