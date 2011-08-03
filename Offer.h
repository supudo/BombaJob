//
//  Offer.h
//  BombaJob
//
//  Created by supudo on 7/5/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbJobOffer.h"
#import "SearchOffer.h"
#import <MessageUI/MessageUI.h>

@interface Offer : UIViewController <MFMailComposeViewControllerDelegate> {
	dbJobOffer *entOffer;
	SearchOffer *searchOffer;
	UIScrollView *scrollView;
	UIView *contentView;
	UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
	UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;
}

@property (nonatomic, retain) dbJobOffer *entOffer;
@property (nonatomic, retain) SearchOffer *searchOffer;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
@property (nonatomic, retain) IBOutlet UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;

- (void)setText:(NSString *)txt control:(UITextView *)txtView;
- (void)loadContent;
- (void)doDesign;
- (void)markAsRead;
- (void)sendMessage;

@end
