//
//  PostOffer.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface PostOffer : UIViewController <WebServiceDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	UIScrollView *scrollView;
	UIView *contentView;
	WebService *webService;
	UIButton *btnHuman, *btnCategory, *btnFreelance, *btnBoom;
	UISwitch *swFreelance;
	NSArray *dataHuman, *dataCategories, *dataFreelance;
	BOOL poHumanYn, poFreelanceYn;
	int poCategoryID;
	UILabel *lblTitle, *lblEmail, *lblNeg, *lblPos;
	UITextField *txtTitle, *txtEmail, *txtNeg, *txtPos;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) IBOutlet UIButton *btnHuman, *btnCategory, *btnFreelance, *btnBoom;
@property (nonatomic, retain) IBOutlet UISwitch *swFreelance;
@property (nonatomic, retain) NSArray *dataHuman, *dataCategories, *dataFreelance;
@property BOOL poHumanYn, poFreelanceYn;
@property int poCategoryID;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle, *lblEmail, *lblNeg, *lblPos;
@property (nonatomic, retain) IBOutlet UITextField *txtTitle, *txtEmail, *txtNeg, *txtPos;

- (void)setUpForm;
- (void)showActionSheet:(NSString *)asTitle type:(int)typeID;
- (IBAction)iboHuman:(id)sender;
- (IBAction)iboCategory:(id)sender;
- (IBAction)iboFreelance:(id)sender;
- (IBAction)iboBoom:(id)sender;

@end
