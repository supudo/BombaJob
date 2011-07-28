//
//  Settings.h
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController {
	UILabel *lblPrivateData, *lblGeo, *lblSync, *lblSearch;
	UISwitch *swPrivateData, *swGeo, *swSync, *swSearch;
}

@property (nonatomic, retain) IBOutlet UILabel *lblPrivateData, *lblGeo, *lblSync, *lblSearch;
@property (nonatomic, retain) IBOutlet UISwitch *swPrivateData, *swGeo, *swSync, *swSearch;

- (IBAction) iboPrivateData:(id)sender;
- (IBAction) iboGeoData:(id)sender;
- (IBAction) iboSyncData:(id)sender;
- (IBAction) iboSearch:(id)sender;

@end
