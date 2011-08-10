//
//  PostOfferText.m
//  BombaJob
//
//  Created by supudo on 7/14/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "PostOfferText.h"

@implementation PostOfferText

@synthesize txtDesc, descID;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"PostOffer", @"PostOffer");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[txtDesc setFont:[UIFont fontWithName:@"Ubuntu" size:14]];
	if (self.descID == 1) {
		if ([bSettings sharedbSettings].currentOffer.HumanYn)
			self.navigationItem.title = NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv");
		else
			self.navigationItem.title = NSLocalizedString(@"Offer_Company_Positiv", @"Offer_Company_Positiv");
		txtDesc.text = [bSettings sharedbSettings].currentOffer.Negativism;
	}
	else {
		if ([bSettings sharedbSettings].currentOffer.HumanYn)
			self.navigationItem.title = NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ");
		else
			self.navigationItem.title = NSLocalizedString(@"Offer_Company_Negativ", @"Offer_Company_Negativ");
		txtDesc.text = [bSettings sharedbSettings].currentOffer.Positivism;
	}
	self.navigationItem.title = [self.navigationItem.title stringByReplacingOccurrencesOfString:@":" withString:@""];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[txtDesc resignFirstResponder];
	if (self.descID == 1)
		[bSettings sharedbSettings].currentOffer.Negativism = txtDesc.text;
	else
		[bSettings sharedbSettings].currentOffer.Positivism = txtDesc.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	return [textView.text length] <= 1000 || [text length] == 0;
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
	txtDesc = nil;
	[txtDesc release];
    [super viewDidUnload];
}

- (void)dealloc {
	[txtDesc release];
    [super dealloc];
}

@end
