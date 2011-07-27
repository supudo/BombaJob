//
//  OfferMessage.h
//  BombaJob
//
//  Created by supudo on 7/5/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbJobOffer.h"
#import "WebService.h"

@interface OfferMessage : UIViewController <WebServiceDelegate> {
	dbJobOffer *entOffer;
	WebService *webService;
	UITextView *txtMessage;
}

@property (nonatomic, retain) dbJobOffer *entOffer;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) IBOutlet UITextView *txtMessage;

- (void)sendMessage;

@end
