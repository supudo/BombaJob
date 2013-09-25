//
//  Search.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Search : UIViewController <UITextFieldDelegate, MapCoordinatesDelegate> {
	UILabel *lblFreelance;
	UITextField *txtSearch;
	UISwitch *swFreelance;
	UIButton *btnSearch, *btnSearchGeo;
}

@property (nonatomic, strong) IBOutlet UILabel *lblFreelance;
@property (nonatomic, strong) IBOutlet UITextField *txtSearch;
@property (nonatomic, strong) IBOutlet UISwitch *swFreelance;
@property (nonatomic, strong) IBOutlet UIButton *btnSearch, *btnSearchGeo;

- (IBAction)iboSearch:(id)sender;
- (IBAction)iboSearchGeo:(id)sender;
- (void)doGeoSearch;

@end
