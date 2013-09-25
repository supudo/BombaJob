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

@property (nonatomic, strong) dbJobOffer *entOffer;
@property (nonatomic, strong) SearchOffer *searchOffer;
@property (nonatomic, strong) WebService *webService;
@property (nonatomic, strong) IBOutlet UITextView *txtMessage;

- (void)sendMessage;

@end
