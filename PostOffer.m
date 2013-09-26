//
//  PostOffer.m
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "PostOffer.h"
#import "BlackAlertView.h"
#import "DBManagedObjectContext.h"
#import "dbCategory.h"
#import "dbSettings.h"
#import "PostOfferText.h"

@implementation PostOffer

@synthesize scrollView, contentView, webService;
@synthesize btnHuman, btnCategory, btnFreelance, btnBoom, swFreelance;
@synthesize dataHuman, dataCategories, dataFreelance;
@synthesize poHumanYn, poFreelanceYn, poCategoryID;
@synthesize lblTitle, lblEmail, lblNeg, lblPos, txtTitle, txtEmail, txtNeg, txtPos;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"PostOffer", @"PostOffer");
	self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];

	scrollView.contentSize = CGSizeMake(320, 550);
	[btnHuman.titleLabel setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
	[btnCategory.titleLabel setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
	[btnFreelance.titleLabel setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
	[btnBoom.titleLabel setFont:[UIFont fontWithName:@"Ubuntu" size:18]];
	[lblTitle setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[lblEmail setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[lblNeg setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[lblPos setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[txtTitle setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[txtEmail setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[txtPos setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[txtNeg setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	[self setUpForm];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (dataHuman == nil)
		dataHuman = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Offer_HumanCompany_1", @"Offer_HumanCompany_1"), NSLocalizedString(@"Offer_HumanCompany_2", @"Offer_HumanCompany_2"), nil];
	if (dataFreelance == nil)
		dataFreelance = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Offer_Freelance_1", @"Offer_Freelance_1"), NSLocalizedString(@"Offer_Freelance_2", @"Offer_Freelance_2"), nil];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CategoryTitle" ascending:YES];
	NSArray *arrSorters = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	dataCategories = [[NSArray alloc] initWithArray:[[DBManagedObjectContext sharedDBManagedObjectContext] getEntities:@"Category" sortDescriptors:arrSorters]];

	txtNeg.text = [bSettings sharedbSettings].currentOffer.Negativism;
	txtPos.text = [bSettings sharedbSettings].currentOffer.Positivism;
	if ([[bSettings sharedbSettings].currentOffer.Negativism length] > 15)
		txtNeg.text = [NSString stringWithFormat:@"%@...", [[bSettings sharedbSettings].currentOffer.Negativism substringToIndex:15]];
	if ([[bSettings sharedbSettings].currentOffer.Positivism length] > 15)
		txtPos.text = [NSString stringWithFormat:@"%@...", [[bSettings sharedbSettings].currentOffer.Positivism substringToIndex:15]];
	[txtNeg resignFirstResponder];
	[txtPos resignFirstResponder];

	[[bSettings sharedbSettings] roundButtonCorners:btnHuman withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:btnFreelance withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:btnCategory withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:txtTitle withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:txtEmail withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:txtNeg withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:txtPos withColor:[UIColor blackColor]];

	poHumanYn = [bSettings sharedbSettings].currentOffer.HumanYn;
	poFreelanceYn = [bSettings sharedbSettings].currentOffer.FreelanceYn;

	[btnHuman setTitle:[NSString stringWithFormat:@"%@ - %@", NSLocalizedString(@"Offer_HumanCompany_Choice", @"Offer_HumanCompany_Choice"), ((poHumanYn) ? NSLocalizedString(@"Offer_HumanCompany_1", @"Offer_HumanCompany_1") : NSLocalizedString(@"Offer_HumanCompany_2", @"Offer_HumanCompany_2"))] forState:UIControlStateNormal];
	[btnFreelance setTitle:[NSString stringWithFormat:@"%@ - %@", NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance"), ((poFreelanceYn) ? NSLocalizedString(@"Offer_Freelance_1", @"Offer_Freelance_1") : NSLocalizedString(@"Offer_Freelance_2", @"Offer_Freelance_2"))] forState:UIControlStateNormal];
	txtEmail.placeholder = NSLocalizedString(@"Offer_PlaceHolder_Human_Email", @"Offer_PlaceHolder_Human_Email");
	txtTitle.placeholder = NSLocalizedString(@"Offer_PlaceHolder_Human_Title", @"Offer_PlaceHolder_Human_Title");
	
	if ([bSettings sharedbSettings].stPrivateData) {
		dbSettings *ent = (dbSettings *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"Email"]];
		if (ent != nil && ![ent.SValue isEqualToString:@""])
			txtEmail.text = ent.SValue;
	}
}

- (void)setUpForm {
	btnHuman.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	btnFreelance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[btnHuman setTitle:NSLocalizedString(@"Offer_HumanCompany_Choice", @"Offer_HumanCompany_Choice") forState:UIControlStateNormal];
	[btnFreelance setTitle:NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance") forState:UIControlStateNormal];
	
	btnCategory.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	btnBoom.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[btnCategory setTitle:NSLocalizedString(@"Offer_Category_Choice", @"Offer_Category_Choice") forState:UIControlStateNormal];
	[btnBoom setTitle:NSLocalizedString(@"Offer_Boom", @"Offer_Boom") forState:UIControlStateNormal];
	
	lblTitle.text = NSLocalizedString(@"Offer_Title", @"Offer_Title");
	lblEmail.text = NSLocalizedString(@"Offer_Email", @"Offer_Email");
	lblNeg.text = NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv");
	lblPos.text = NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == txtNeg || textField == txtPos) {
		[textField resignFirstResponder];
		[self textFieldDidBeginEditing:textField];
		return FALSE;
	}
	else
		return [textField.text length] <= 500 || [string length] == 0;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (textField == txtNeg || textField == txtPos) {
		[textField resignFirstResponder];
		PostOfferText *tvc = [[PostOfferText alloc] initWithNibName:@"PostOfferText" bundle:nil];
		if (textField == txtNeg)
			tvc.descID = 1;
		else
			tvc.descID = 2;
		[[self navigationController] pushViewController:tvc animated:YES];
	}
	else {
		int kbHeight = 0;
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
			kbHeight = 162;
		else
			kbHeight = 216;
		
		UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbHeight, 0.0);
		scrollView.contentInset = contentInsets;
		scrollView.scrollIndicatorInsets = contentInsets;
		
		CGRect aRect = self.view.frame;
		aRect.size.height -= kbHeight;
		if (!CGRectContainsPoint(aRect, textField.frame.origin) ) {
			CGPoint scrollPoint;
			if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
				scrollPoint = CGPointMake(0.0, textField.frame.origin.y - kbHeight + 88);
			else
				scrollPoint = CGPointMake(0.0, textField.frame.origin.y - kbHeight + 44);
			[scrollView setContentOffset:scrollPoint animated:YES];
		}
	}
}

- (IBAction)iboHuman:(id)sender {
	[self showActionSheet:NSLocalizedString(@"Offer_HumanCompany_Choice", @"Offer_HumanCompany_Choice") type:1];
}

- (IBAction)iboFreelance:(id)sender {
	[self showActionSheet:NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance") type:2];
}

- (IBAction)iboCategory:(id)sender {
	[self showActionSheet:NSLocalizedString(@"Offer_Category", @"Offer_Category") type:3];
}

- (void)showActionSheet:(NSString *)asTitle type:(int)typeID {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:asTitle delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") destructiveButtonTitle:nil otherButtonTitles:nil];
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, 0, 0)];
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	pickerView.tag = typeID;
	menu.tag = typeID;
	[menu addSubview:pickerView];
	[menu showFromTabBar:appDelegate.tabBarController.tabBar];
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		[menu setBounds:CGRectMake(0, 0, 480, 440)];
	else
		[menu setBounds:CGRectMake(0, 0, 320, 580)];
	
	switch (typeID) {
		case 1: {
			if ([bSettings sharedbSettings].currentOffer.HumanYn)
				[pickerView selectRow:0 inComponent:0 animated:YES];
			else
				[pickerView selectRow:1 inComponent:0 animated:YES];
			break;
		}
		case 2: {
			if ([bSettings sharedbSettings].currentOffer.FreelanceYn)
				[pickerView selectRow:0 inComponent:0 animated:YES];
			else
				[pickerView selectRow:1 inComponent:0 animated:YES];
			break;
		}
		case 3: {
			for (int i=0; i<[dataCategories count]; i++) {
				if ([bSettings sharedbSettings].currentOffer.CategoryID == [[[dataCategories objectAtIndex:i] valueForKey:@"CategoryID"] intValue])
					[pickerView selectRow:i inComponent:0 animated:YES];
			}
			break;
		}
		default:
			break;
	}
	
}

- (IBAction)iboBoom:(id)sender {
	[bSettings sharedbSettings].currentOffer.Title = txtTitle.text;
	[bSettings sharedbSettings].currentOffer.Email	= txtEmail.text;

	[[bSettings sharedbSettings] roundButtonCorners:txtTitle withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:txtEmail withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:txtNeg withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:txtPos withColor:[UIColor blackColor]];
	[[bSettings sharedbSettings] roundButtonCorners:btnCategory withColor:[UIColor blackColor]];

	BOOL validationError = TRUE;
	if ([txtTitle.text isEqualToString:@""])
		[[bSettings sharedbSettings] roundButtonCorners:txtTitle withColor:[UIColor redColor]];
	else if ([txtEmail.text isEqualToString:@""] || ![[bSettings sharedbSettings] validEmail:txtEmail.text sitrictly:TRUE])
		[[bSettings sharedbSettings] roundButtonCorners:txtEmail withColor:[UIColor redColor]];
	else if ([txtNeg.text isEqualToString:@""])
		[[bSettings sharedbSettings] roundButtonCorners:txtNeg withColor:[UIColor redColor]];
	else if ([txtPos.text isEqualToString:@""])
		[[bSettings sharedbSettings] roundButtonCorners:txtPos withColor:[UIColor redColor]];
	else if ([bSettings sharedbSettings].currentOffer.CategoryID == 0)
		[[bSettings sharedbSettings] roundButtonCorners:btnCategory withColor:[UIColor redColor]];
	else
		validationError = FALSE;

	if (validationError) {
		NSString *msg = NSLocalizedString(@"Offer_MissingReqFields", @"Offer_MissingReqFields");
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles: nil];
		alert.tag = 3;
		[alert show];
	}
	else {
		if ([bSettings sharedbSettings].stPrivateData) {
			DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
			dbSettings *ent = (dbSettings *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"Email"]];
			if (ent != nil)
				ent.SValue = [bSettings sharedbSettings].currentOffer.Email;
			else {
				ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
				[ent setSName:@"Email"];
				[ent setSValue:[bSettings sharedbSettings].currentOffer.Email];

				NSError *error = nil;
				if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
					[[bSettings sharedbSettings] LogThis:@"Error while saving the account info: %@", [error userInfo]];
					abort();
				}
			}
		}

		[[bSettings sharedbSettings] startLoading:self.view];
		if (webService == nil)
			webService = [[WebService alloc] init];
		[webService setDelegate:self];
		[webService postNewJob];
	}
}

- (void)postJobFinished:(id)sender {
	[[bSettings sharedbSettings].currentOffer clearAll];
	[self setUpForm];
	[[bSettings sharedbSettings] stopLoading:self.view];
	NSString *msg = NSLocalizedString(@"Offer_ThankYou", @"Offer_ThankYou");
	if (![bSettings sharedbSettings].currentPostOfferResult)
		msg = [NSString stringWithFormat:@"%@!", NSLocalizedString(@"Error", @"Error")];
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles: nil];
	alert.tag = 2;
	[alert show];
}

- (void)serviceError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Error", @"Error"), errorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles: nil];
	alert.tag = 1;
	[alert show];
}

#pragma mark -
#pragma mark Delegates

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 1) {
	}
	else if (actionSheet.tag == 2)
		[[bSettings sharedbSettings] clearPostData];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (pickerView.tag == 1)
		return [dataHuman count];
	else if (pickerView.tag == 2)
		return [dataFreelance count];
	else
		return [dataCategories count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *retval = (id)view;
	if (!retval)
		retval = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
	NSString *lbl;
	if (pickerView.tag == 1) {
		lbl = [NSString stringWithFormat:@"Offer_HumanCompany_%i", (row + 1)];
		lbl = NSLocalizedString(lbl, lbl);
	}
	else if (pickerView.tag == 2) {
		lbl = [NSString stringWithFormat:@"Offer_Freelance_%i", (row + 1)];
		lbl = NSLocalizedString(lbl, lbl);
	}
	else
		lbl = ((dbCategory *)[dataCategories objectAtIndex:row]).CategoryTitle;
	retval.text = lbl;
	[retval setFont:[UIFont fontWithName:@"Ubuntu" size:20]];
	[retval setBackgroundColor:[UIColor clearColor]];
	return retval;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (pickerView.tag == 1)
		poHumanYn = ((row == 0) ? TRUE : FALSE);
	else if (pickerView.tag == 2)
		poFreelanceYn = ((row == 0) ? TRUE : FALSE);
	else
		poCategoryID = [[[dataCategories objectAtIndex:row] valueForKey:@"CategoryID"] intValue];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		if (actionSheet.tag == 1) {
			[bSettings sharedbSettings].currentOffer.HumanYn = poHumanYn;
			if (poHumanYn) {
				lblPos.text = NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv");
				lblNeg.text = NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ");
				txtEmail.placeholder = NSLocalizedString(@"Offer_PlaceHolder_Human_Email", @"Offer_PlaceHolder_Human_Email");
				txtTitle.placeholder = NSLocalizedString(@"Offer_PlaceHolder_Human_Title", @"Offer_PlaceHolder_Human_Title");
			}
			else {
				lblPos.text = NSLocalizedString(@"Offer_Company_Positiv", @"Offer_Company_Positiv");
				lblNeg.text = NSLocalizedString(@"Offer_Company_Negativ", @"Offer_Company_Negativ");
				txtEmail.placeholder = NSLocalizedString(@"Offer_PlaceHolder_Company_Email", @"Offer_PlaceHolder_Company_Email");
				txtTitle.placeholder = NSLocalizedString(@"Offer_PlaceHolder_Company_Title", @"Offer_PlaceHolder_Company_Title");
			}
			[btnHuman setTitle:[NSString stringWithFormat:@"%@ - %@", NSLocalizedString(@"Offer_HumanCompany_Choice", @"Offer_HumanCompany_Choice"), ((poHumanYn) ? NSLocalizedString(@"Offer_HumanCompany_1", @"Offer_HumanCompany_1") : NSLocalizedString(@"Offer_HumanCompany_2", @"Offer_HumanCompany_2"))] forState:UIControlStateNormal];
		}
		else if (actionSheet.tag == 2) {
			[bSettings sharedbSettings].currentOffer.FreelanceYn = poFreelanceYn;
			[btnFreelance setTitle:[NSString stringWithFormat:@"%@ - %@", NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance"), ((poFreelanceYn) ? NSLocalizedString(@"Offer_Freelance_1", @"Offer_Freelance_1") : NSLocalizedString(@"Offer_Freelance_2", @"Offer_Freelance_2"))] forState:UIControlStateNormal];
		}
		else {
			[bSettings sharedbSettings].currentOffer.CategoryID = poCategoryID;
			for (int i=0; i<[dataCategories count]; i++) {
				if (poCategoryID == [[[dataCategories objectAtIndex:i] valueForKey:@"CategoryID"] intValue])
					[btnCategory setTitle:[[dataCategories objectAtIndex:i] valueForKey:@"CategoryTitle"] forState:UIControlStateNormal];
			}
		}
	}
}

#pragma mark -
#pragma mark System

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ? NO : [bSettings sharedbSettings].shouldRotate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	scrollView = nil;
	contentView = nil;
	webService = nil;
	btnHuman = nil;
	btnCategory = nil;
	btnFreelance = nil;
	btnBoom = nil;
	swFreelance = nil;
	dataHuman = nil;
	dataCategories = nil;
	dataFreelance = nil;
	lblTitle = nil;
	lblEmail = nil;
	lblNeg = nil;
	lblPos = nil;
	txtTitle = nil;
	txtEmail = nil;
	txtNeg = nil;
	txtPos = nil;
    [super viewDidUnload];
}


@end
