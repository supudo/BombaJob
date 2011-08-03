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
#import "BlackAlertView.h"
#import "DBManagedObjectContext.h"

@implementation Offer

@synthesize entOffer, searchOffer;
@synthesize scrollView, contentView;
@synthesize txtCategory, txtTitle, txtPositivism, txtNegativism;
@synthesize lblDate, lblFreelance, lblLPositiv, lblLNegativ;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	if (entOffer == nil)
		self.navigationItem.title = searchOffer.Title;
	else
		self.navigationItem.title = entOffer.Title;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendMessage)] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	scrollView.contentSize = CGSizeMake(320, 400);
	[self loadContent];
	[self doDesign];
}

- (void)loadContent {
	if (searchOffer == nil) {
		if ([entOffer.HumanYn boolValue])
			lblFreelance.text = NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance");
		else
			lblFreelance.hidden = YES;
		
		lblDate.text = [[bSettings sharedbSettings] getOfferDate:entOffer.PublishDate];
		
		[self setText:entOffer.CategoryTitle control:txtCategory];
		[self setText:entOffer.Title control:txtTitle];
		
		if ([entOffer.HumanYn boolValue]) {
			lblLPositiv.text = NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv");
			lblLNegativ.text = NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ");
		}
		else {
			lblLPositiv.text = NSLocalizedString(@"Offer_Company_Positiv", @"Offer_Company_Positiv");
			lblLNegativ.text = NSLocalizedString(@"Offer_Company_Negativ", @"Offer_Company_Negativ");
		}
		
		[self setText:entOffer.Positivism control:txtPositivism];
		[self setText:entOffer.Negativism control:txtNegativism];
	}
	else {
		if (searchOffer.HumanYn)
			lblFreelance.text = NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance");
		else
			lblFreelance.hidden = YES;
		
		lblDate.text = [[bSettings sharedbSettings] getOfferDate:searchOffer.PublishDate];
		
		[self setText:searchOffer.CategoryTitle control:txtCategory];
		[self setText:searchOffer.Title control:txtTitle];
		
		if (searchOffer.HumanYn) {
			lblLPositiv.text = NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv");
			lblLNegativ.text = NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ");
		}
		else {
			lblLPositiv.text = NSLocalizedString(@"Offer_Company_Positiv", @"Offer_Company_Positiv");
			lblLNegativ.text = NSLocalizedString(@"Offer_Company_Negativ", @"Offer_Company_Negativ");
		}
		[self setText:searchOffer.Positivism control:txtPositivism];
		[self setText:searchOffer.Negativism control:txtNegativism];
	}
	[self markAsRead];
}

- (void)markAsRead {
	if (searchOffer == nil) {
		DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
		dbJobOffer *entPD = (dbJobOffer *)[dbManagedObjectContext getEntity:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"OfferID = %@", entOffer.OfferID]];
		[entPD setReadYn:[NSNumber numberWithInt:1]];
		NSError *error = nil;
		if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
			[[bSettings sharedbSettings] LogThis:[NSString stringWithFormat:@"Error while saving settings: %@", [error userInfo]]];
			abort();
		}

		UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:0];
		tb.badgeValue = [NSString stringWithFormat:@"%i", [[DBManagedObjectContext sharedDBManagedObjectContext] getEntitiesCount:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"ReadYn = 0"]]];
		if ([entOffer.HumanYn boolValue]) {
			UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:2];
			tb.badgeValue = [NSString stringWithFormat:@"%i", [[DBManagedObjectContext sharedDBManagedObjectContext] getEntitiesCount:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 1 AND ReadYn = 0"]]];
		}
		else {
			UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:1];
			tb.badgeValue = [NSString stringWithFormat:@"%i", [[DBManagedObjectContext sharedDBManagedObjectContext] getEntitiesCount:@"JobOffer" predicate:[NSPredicate predicateWithFormat:@"HumanYn = 0 AND ReadYn = 0"]]];
		}
	}
	else {
		for (SearchOffer *off in [bSettings sharedbSettings].latestSearchResults) {
			if (off.OfferID == searchOffer.OfferID)
				off.ReadYn = 1;
		}
		UITabBarItem *tb = (UITabBarItem *)[[appDelegate tabBarController].tabBar.items objectAtIndex:3];
		tb.badgeValue = [NSString stringWithFormat:@"%i", ([tb.badgeValue intValue] - 1)];
	}
}

- (void)sendMessage {
	if ([bSettings sharedbSettings].stInAppEmail) {
		if ([MFMailComposeViewController canSendMail]) {
			MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
			[mailController setMailComposeDelegate:self];
			NSString *subject = [NSString stringWithFormat:@"%@%i", NSLocalizedString(@"Offer_EmailSubject", @"Offer_EmailSubject"), ((entOffer == nil) ? searchOffer.OfferID : [entOffer.OfferID intValue])];
			[mailController setSubject:subject];
			[mailController setToRecipients:[NSArray arrayWithObjects:((entOffer == nil) ? searchOffer.Email : entOffer.Email), nil]];
			[mailController setCcRecipients:nil];
			[mailController setBccRecipients:nil];
			[mailController setMessageBody:[NSString stringWithFormat:@"<br /><br /> Sent from BombaJob ..."] isHTML:YES];
			[mailController.navigationBar setBarStyle:UIBarStyleBlack];
			[self presentModalViewController:mailController animated:YES];
			[mailController release];
		}
		else {
			[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Error.InAppEmailCantSend", @"Error.InAppEmailCantSend")] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
			alert.tag = 1;
			[alert show];
			[alert release];
		}
	}
	else {
		OfferMessage *tvc = [[OfferMessage alloc] initWithNibName:@"OfferMessage" bundle:nil];
		if (searchOffer == nil)
			tvc.entOffer = entOffer;
		else
			tvc.searchOffer = searchOffer;
		[[self navigationController] pushViewController:tvc animated:YES];
		[tvc release];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default: {
			[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:@"..." delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
			alert.tag = 1;
			[alert show];
			[alert release];
			break;
		}
	}
	[self dismissModalViewControllerAnimated:YES];
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
	[lblDate setFont:[UIFont fontWithName:@"Ubuntu-Italic" size:14]];
	[txtTitle setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[lblLPositiv setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[lblLNegativ setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[txtPositivism setDataDetectorTypes:UIDataDetectorTypeLink];
	[txtNegativism setDataDetectorTypes:UIDataDetectorTypeLink];

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
	searchOffer = nil;
	[searchOffer release];
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
	[searchOffer release];
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
