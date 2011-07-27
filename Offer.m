//
//  Offer.m
//  BombaJob
//
//  Created by supudo on 7/5/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "Offer.h"
#import "OfferMessage.h"
#import <QuartzCore/QuartzCore.h>

@implementation Offer

@synthesize entOffer;
@synthesize scrollView, contentView;
@synthesize txtCategory, txtTitle, txtPositivism, txtNegativism;
@synthesize lblDate, lblFreelance, lblLPositiv, lblLNegativ;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = entOffer.Title;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendMessage)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	scrollView.contentSize = CGSizeMake(320, 400);

	if ([entOffer.HumanYn boolValue])
		lblFreelance.text = NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance");
	else
		lblFreelance.hidden = YES;

	lblDate.text = [[bSettings sharedbSettings] getOfferDate:entOffer.PublishDate];
	[lblDate setFont:[UIFont fontWithName:@"Ubuntu-Italic" size:14]];

	[self setText:entOffer.CategoryTitle control:txtCategory];
	[self setText:entOffer.Title control:txtTitle];
	[txtTitle setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];

	if ([entOffer.HumanYn boolValue]) {
		lblLPositiv.text = NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv");
		lblLNegativ.text = NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ");
	}
	else {
		lblLPositiv.text = NSLocalizedString(@"Offer_Company_Positiv", @"Offer_Company_Positiv");
		lblLNegativ.text = NSLocalizedString(@"Offer_Company_Negativ", @"Offer_Company_Negativ");
	}
	
	[lblLPositiv setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[lblLNegativ setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[self setText:entOffer.Positivism control:txtPositivism];
	[self setText:entOffer.Negativism control:txtNegativism];
	[txtPositivism setDataDetectorTypes:UIDataDetectorTypeLink];
	[txtNegativism setDataDetectorTypes:UIDataDetectorTypeLink];
	
	[self doDesign];
}

- (void)sendMessage {
	OfferMessage *tvc = [[OfferMessage alloc] initWithNibName:@"OfferMessage" bundle:nil];
	tvc.entOffer = entOffer;
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

- (void)setText:(NSString *)txt control:(UITextView *)txtView {
	txtView.text = txt;
	txtView.font = [UIFont fontWithName:@"Ubuntu" size:14];
	txtView.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtView.layer.cornerRadius = 5;
	txtView.clipsToBounds = YES;
	CGRect frameTemp = txtView.frame;
	frameTemp.origin.x = 4;
	frameTemp.size.width = 312;
	txtView.frame = frameTemp;
}

- (void)doDesign {
	CGRect frameTemp;

	// Category text
	frameTemp = txtCategory.frame;
	frameTemp.size.height = txtCategory.contentSize.height;
	frameTemp.origin.y = self.view.frame.origin.y + 6;
	txtCategory.frame = frameTemp;

	// Title text
	frameTemp = txtTitle.frame;
	frameTemp.size.height = txtTitle.contentSize.height;
	frameTemp.origin.y = txtCategory.frame.origin.y + txtCategory.frame.size.height + 4;
	txtTitle.frame = frameTemp;

	// Date label
	frameTemp = lblDate.frame;
	frameTemp.origin.y = txtTitle.frame.origin.y + txtTitle.frame.size.height + 4;
	frameTemp.origin.x = 6;
	frameTemp.size.width = 312;
	lblDate.frame = frameTemp;

	// Freelance label
	if (lblFreelance.hidden) {
		frameTemp = lblFreelance.frame;
		frameTemp.size.height = 0;
		lblFreelance.frame = frameTemp;
	}
	else {
		frameTemp = lblFreelance.frame;
		frameTemp.origin.y = lblDate.frame.origin.y + lblDate.frame.size.height + 4;
		frameTemp.origin.x = 6;
		frameTemp.size.width = 312;
		lblFreelance.frame = frameTemp;
	}

	// Positiv label
	frameTemp = lblLPositiv.frame;
	frameTemp.origin.y = lblFreelance.frame.origin.y + lblFreelance.frame.size.height + 4;
	frameTemp.origin.x = 6;
	frameTemp.size.width = 312;
	lblLPositiv.frame = frameTemp;

	// Positiv text
	frameTemp = txtPositivism.frame;
	frameTemp.size.height = txtPositivism.contentSize.height;
	frameTemp.origin.y = lblLPositiv.frame.origin.y + lblLPositiv.frame.size.height + 4;
	txtPositivism.frame = frameTemp;
	
	// Negativ label
	frameTemp = lblLNegativ.frame;
	frameTemp.origin.y = txtPositivism.frame.origin.y + txtPositivism.frame.size.height + 4;
	frameTemp.origin.x = 6;
	frameTemp.size.width = 312;
	lblLNegativ.frame = frameTemp;
	
	// Negativ text
	frameTemp = txtNegativism.frame;
	frameTemp.size.height = txtNegativism.contentSize.height;
	frameTemp.origin.y = lblLNegativ.frame.origin.y + lblLNegativ.frame.size.height + 4;
	txtNegativism.frame = frameTemp;

	// Content view
	frameTemp = contentView.frame;
	frameTemp.size.height = txtNegativism.frame.origin.y + txtNegativism.frame.size.height + 4;
	contentView.frame = frameTemp;
	
	// Scroll view
	frameTemp = scrollView.frame;
	scrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
	scrollView.frame = frameTemp;
	
	// self
	frameTemp = self.view.frame;
	frameTemp.size.height = scrollView.frame.size.height;
	self.view.frame = frameTemp;
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	entOffer = nil;
	[entOffer release];
	scrollView = nil;
	[scrollView release];
	contentView = nil;
	[contentView release];
	txtCategory = nil;
	[txtCategory release];
	txtTitle = nil;
	[txtTitle release];
	txtPositivism = nil;
	[txtPositivism release];
	txtNegativism = nil;
	[txtNegativism release];
	lblDate = nil;
	[lblDate release];
	lblFreelance = nil;
	[lblFreelance release];
	lblLPositiv = nil;
	[lblLPositiv release];
	lblLNegativ = nil;
	[lblLNegativ release];
    [super viewDidUnload];
}

- (void)dealloc {
	[entOffer release];
	[scrollView release];
	[contentView release];
	[txtCategory release];
	[txtTitle release];
	[txtPositivism release];
	[txtNegativism release];
	[lblDate release];
	[lblFreelance release];
	[lblLPositiv release];
	[lblLNegativ release];
    [super dealloc];
}

@end
