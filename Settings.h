//
//  Settings.h
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController <UIActionSheetDelegate> {
	UILabel *lblPrivateData, *lblGeo, *lblSync, *lblSearch, *lblInAppEmail;
	UISwitch *swPrivateData, *swGeo, *swSync, *swSearch, *swInAppEmail;
	BOOL helpOnScreen;
	UIActionSheet *helpScreen;
}

@property (nonatomic, retain) IBOutlet UILabel *lblPrivateData, *lblGeo, *lblSync, *lblSearch, *lblInAppEmail;
@property (nonatomic, retain) IBOutlet UISwitch *swPrivateData, *swGeo, *swSync, *swSearch, *swInAppEmail;
@property BOOL helpOnScreen;
@property (nonatomic, retain) UIActionSheet *helpScreen;

- (IBAction) iboPrivateData:(id)sender;
- (IBAction) iboGeoData:(id)sender;
- (IBAction) iboSyncData:(id)sender;
- (IBAction) iboSearch:(id)sender;
- (IBAction) iboInAppEmail:(id)sender;
- (IBAction) iboHelpPrivateData:(id)sender;
- (IBAction) iboHelpGeoData:(id)sender;
- (IBAction) iboHelpSyncData:(id)sender;
- (IBAction) iboHelpSearch:(id)sender;
- (IBAction) iboHelpInAppEmail:(id)sender;
- (void)showHelp:(NSString *)helpTitle withContent:(NSString *)helpContent;

@end
