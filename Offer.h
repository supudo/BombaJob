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
#import "WebService.h"
#import "BlackAlertView.h"
#import <iAd/iAd.h>

@interface Offer : UIViewController <MFMailComposeViewControllerDelegate, WebServiceDelegate, ADBannerViewDelegate> {
	dbJobOffer *entOffer;
	SearchOffer *searchOffer;
	UIScrollView *scrollView;
	UIView *contentView;
	UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
	UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;
    UIButton *btnEmail, *btnTwitter, *btnFacebook;
    ADBannerView *bannerView;
	WebService *webService;
}

@property (nonatomic, strong) dbJobOffer *entOffer;
@property (nonatomic, strong) SearchOffer *searchOffer;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
@property (nonatomic, strong) IBOutlet UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;
@property (nonatomic, strong) IBOutlet UIButton *btnEmail, *btnTwitter, *btnFacebook;
@property (nonatomic, strong) IBOutlet ADBannerView *bannerView;
@property (nonatomic, strong) WebService *webService;

- (void)setText:(NSString *)txt control:(UITextView *)txtView;
- (void)loadContent;
- (void)doDesign;
- (void)markAsRead;
- (void)sendMessage;
- (IBAction)sendEmail:(id)sender;
- (IBAction)sendFacebook:(id)sender;
- (IBAction)sendTwitter:(id)sender;
- (void)showEmailBox;
- (void)showBanner;
- (void)layoutForCurrentOrientation:(BOOL)animated;

@end
