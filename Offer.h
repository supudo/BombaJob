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
// Twitter
#import "SA_OAuthTwitterController.h"

@class SA_OAuthTwitterEngine;
@class MPOAuthAPI;

@interface Offer : UIViewController <MFMailComposeViewControllerDelegate, WebServiceDelegate, ADBannerViewDelegate,
									SA_OAuthTwitterControllerDelegate,
									FBDialogDelegate, FBSessionDelegate> {
	dbJobOffer *entOffer;
	SearchOffer *searchOffer;
	UIScrollView *scrollView;
	UIView *contentView;
	UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
	UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;
    UIButton *btnEmail, *btnTwitter, *btnFacebook;
    ADBannerView *bannerView;
	WebService *webService;
	SA_OAuthTwitterEngine *_twitterEngine;
    BOOL facebookPostSuccess;
}

@property (nonatomic, retain) dbJobOffer *entOffer;
@property (nonatomic, retain) SearchOffer *searchOffer;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITextView *txtCategory, *txtTitle, *txtPositivism, *txtNegativism;
@property (nonatomic, retain) IBOutlet UILabel *lblDate, *lblFreelance, *lblLPositiv, *lblLNegativ;
@property (nonatomic, retain) IBOutlet UIButton *btnEmail, *btnTwitter, *btnFacebook;
@property (nonatomic, retain) IBOutlet ADBannerView *bannerView;
@property (nonatomic, retain) WebService *webService;
@property BOOL facebookPostSuccess;

- (void)setText:(NSString *)txt control:(UITextView *)txtView;
- (void)loadContent;
- (void)doDesign;
- (void)markAsRead;
- (void)sendMessage;
- (IBAction)sendEmail:(id)sender;
- (IBAction)sendFacebook:(id)sender;
- (IBAction)sendTwitter:(id)sender;
- (void)showEmailBox;
- (void)twitterPost;
- (void)showBanner;
- (void)layoutForCurrentOrientation:(BOOL)animated;
- (NSDictionary *)parseFacebookURL:(NSString *)query;
- (BOOL)isTwitterSDKAvailable;

@end
