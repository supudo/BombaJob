//
//  Search.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Search : UIViewController <UITextFieldDelegate> {
	UILabel *lblFreelance;
	UITextField *txtSearch;
	UISwitch *swFreelance;
	UIButton *btnSearch;
}

@property (nonatomic, retain) IBOutlet UILabel *lblFreelance;
@property (nonatomic, retain) IBOutlet UITextField *txtSearch;
@property (nonatomic, retain) IBOutlet UISwitch *swFreelance;
@property (nonatomic, retain) IBOutlet UIButton *btnSearch;

- (IBAction)iboSearch:(id)sender;

@end
