//
//  Settings.h
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController {
	UILabel *lblPrivateData, *lblGeo, *lblSync;
	UISwitch *swPrivateData, *swGeo, *swSync;
}

@property (nonatomic, retain) IBOutlet UILabel *lblPrivateData, *lblGeo, *lblSync;
@property (nonatomic, retain) IBOutlet UISwitch *swPrivateData, *swGeo, *swSync;

- (IBAction) iboPrivateData:(id)sender;
- (IBAction) iboGeoData:(id)sender;
- (IBAction) iboSyncData:(id)sender;

@end
