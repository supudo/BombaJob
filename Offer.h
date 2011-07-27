//
//  Offer.h
//  BombaJob
//
//  Created by supudo on 7/5/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbJobOffer.h"

@interface Offer : UIViewController {
	dbJobOffer *entOffer;
	UIScrollView *scrollView;
	UIView *contentView;
	UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
	UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;
}

@property (nonatomic, retain) dbJobOffer *entOffer;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
@property (nonatomic, retain) IBOutlet UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;

- (void)setText:(NSString *)txt control:(UITextView *)txtView;
- (void)doDesign;
- (void)sendMessage;

@end
