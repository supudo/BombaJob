//
//  OfferMessage.h
//  BombaJob
//
//  Created by supudo on 7/5/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbJobOffer.h"
#import "SearchOffer.h"
#import "WebService.h"

@interface OfferMessage : UIViewController <WebServiceDelegate> {
	dbJobOffer *entOffer;
	SearchOffer *searchOffer;
	WebService *webService;
	UITextView *txtMessage;
}

@property (nonatomic, retain) dbJobOffer *entOffer;
@property (nonatomic, retain) SearchOffer *searchOffer;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) IBOutlet UITextView *txtMessage;

- (void)sendMessage;

@end
