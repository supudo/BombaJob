//
//  Loading.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface Loading : UIViewController <WebServiceDelegate> {
	NSTimer *timer;
	WebService *webService;
	UILabel *lblLoading;
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) IBOutlet UILabel *lblLoading;

- (void)startSync;
- (void)startSyncTimer;
- (void)finishSync;
- (void)startTabApp;

@end
