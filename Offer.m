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
#import "DBManagedObjectContext.h"
#import "dbSettings.h"
#import "SA_OAuthTwitterEngine.h"
#import "DDAlertPrompt.h"

#define kOFFSET_FOR_KEYBOARD 60.0

@implementation Offer

@synthesize entOffer, searchOffer;
@synthesize scrollView, contentView, bannerView;
@synthesize txtCategory, txtTitle, txtPositivism, txtNegativism;
@synthesize lblDate, lblFreelance, lblLPositiv, lblLNegativ;
@synthesize btnEmail, btnTwitter, btnFacebook, webService, facebookPostSuccess;

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
	if (webService == nil)
		webService = [[WebService alloc] init];

	[bSettings sharedbSettings]._facebookEngine = [[Facebook alloc] initWithAppId:[bSettings sharedbSettings].facebookAppID urlSchemeSuffix:@"iphone" andDelegate:self];
	//https://developers.facebook.com/docs/guides/mobile/
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [bSettings sharedbSettings]._facebookEngine.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [bSettings sharedbSettings]._facebookEngine.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	scrollView.contentSize = CGSizeMake(320, 450);

	[self loadContent];
	[self doDesign];
    [self showBanner];
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
			[[bSettings sharedbSettings] LogThis:@"Error while saving settings: %@", [error userInfo]];
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

- (void)setText:(NSString *)txt control:(UITextView *)txtView {
	txtView.text = txt;
	txtView.font = [UIFont fontWithName:@"Ubuntu" size:14];
	txtView.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtView.layer.cornerRadius = 5;
	txtView.clipsToBounds = YES;
	CGRect frameTemp = txtView.frame;
	frameTemp.origin.x = 4;
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		frameTemp.size.width = 472;
	else
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

	[btnEmail.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[[bSettings sharedbSettings] roundButtonCorners:btnEmail withColor:[UIColor blackColor]];
	[btnFacebook.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[[bSettings sharedbSettings] roundButtonCorners:btnFacebook withColor:[UIColor blackColor]];
	[btnTwitter.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[[bSettings sharedbSettings] roundButtonCorners:btnTwitter withColor:[UIColor blackColor]];

	CGRect frameTemp;

	// Category text
	frameTemp = txtCategory.frame;
	frameTemp.size.height = txtCategory.contentSize.height;
	frameTemp.origin.y = self.view.frame.origin.y + 34 + 6;
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
	scrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height + 50);
	scrollView.frame = frameTemp;
	
	// self
	frameTemp = self.view.frame;
	frameTemp.size.height = scrollView.frame.size.height + 50;
	self.view.frame = frameTemp;
}

- (void)showBanner {
    if ([bSettings sharedbSettings].stShowBanners) {
        self.bannerView.requiredContentSizeIdentifiers = (&ADBannerContentSizeIdentifierPortrait != nil) ?
        [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil] : 
        [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, ADBannerContentSizeIdentifier480x32, nil];
        [self layoutForCurrentOrientation:NO];
    }
    else
        self.bannerView.hidden = YES;
}

#pragma mark -
#pragma mark Email

- (void)showEmailBox {
	DDAlertPrompt *emailAlert = [[DDAlertPrompt alloc] initWithTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Offer_EmailEnterYourEmail", @"Offer_EmailEnterYourEmail")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.Cancel", @"UI.Cancel") otherButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK")];	
	emailAlert.tag = 3;
	[emailAlert show];
	[emailAlert release];	
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ([alertView isKindOfClass:[DDAlertPrompt class]]) {
		DDAlertPrompt *emailAlert = (DDAlertPrompt *)alertView;
		[emailAlert.plainTextField1 becomeFirstResponder];		
		[emailAlert setNeedsLayout];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 3 && buttonIndex == 1) {
		DDAlertPrompt *emailAlert = (DDAlertPrompt *)actionSheet;
		NSString *fromEmail = [emailAlert.plainTextField1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		NSString *toEmail = [emailAlert.plainTextField2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if (toEmail != nil && ![toEmail isEqualToString:@""] && [[bSettings sharedbSettings] validEmail:toEmail sitrictly:TRUE] &&
			fromEmail != nil && ![fromEmail isEqualToString:@""] && [[bSettings sharedbSettings] validEmail:fromEmail sitrictly:TRUE]) {
			if ([bSettings sharedbSettings].stPrivateData) {
				DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
				dbSettings *ent = (dbSettings *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"Settings" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"Email"]];
				if (ent != nil)
					ent.SValue = fromEmail;
				else {
					ent = (dbSettings *)[NSEntityDescription insertNewObjectForEntityForName:@"Settings" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
					[ent setSName:@"Email"];
					[ent setSValue:fromEmail];
					NSError *error = nil;
					if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
						[[bSettings sharedbSettings] LogThis:@"Error while saving the account info: %@", [error userInfo]];
						abort();
					}
				}
			}
			
			[self.webService setDelegate:self];
			[self.webService sendEmailMessage:((searchOffer == nil) ? [entOffer.OfferID intValue] : searchOffer.OfferID) toEmail:toEmail fromEmail:fromEmail];
		}
		else {
			[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Offer_EmailIncorrectEmail", @"Offer_EmailIncorrectEmail")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
			alert.tag = 4;
			[alert show];
			[alert release];
		}
	}
	else if (actionSheet.tag == 4)
		[self showEmailBox];
}

- (IBAction)sendEmail:(id)sender {
	if ([bSettings sharedbSettings].stInAppEmail) {
		if ([MFMailComposeViewController canSendMail]) {
			MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
			[mailController setMailComposeDelegate:self];
			NSString *subject = [NSString stringWithFormat:@"%@ #%i", NSLocalizedString(@"Offer_EmailSubjectByUser", @"Offer_EmailSubjectByUser"), ((entOffer == nil) ? searchOffer.OfferID : [entOffer.OfferID intValue])];
			[mailController setSubject:subject];
			[mailController setToRecipients:[NSArray arrayWithObjects:((entOffer == nil) ? searchOffer.Email : entOffer.Email), nil]];
			[mailController setCcRecipients:nil];
			[mailController setBccRecipients:nil];
			
			NSMutableString *eb = [[NSMutableString alloc] init];
			[eb setString:@""];
			[eb appendFormat:@"%@<br /><br />", ((entOffer == nil) ? searchOffer.CategoryTitle : entOffer.CategoryTitle)];
			[eb appendFormat:@"<b>%@</b><br /><br />", ((entOffer == nil) ? searchOffer.Title : entOffer.Title)];
			[eb appendFormat:@"<i>%@</i><br /><br />", [[bSettings sharedbSettings] getOfferDate:((entOffer == nil) ? searchOffer.PublishDate : entOffer.PublishDate)]];
			
			if (entOffer == nil) {
				if (searchOffer.HumanYn) {
					if (searchOffer.FreelanceYn)
						[eb appendFormat:@"%@<br /><br />", NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance")];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv"), searchOffer.Positivism];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ"), searchOffer.Negativism];
				}
				else {
					if (searchOffer.FreelanceYn)
						[eb appendFormat:@"%@<br /><br />", NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance")];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Company_Positiv", @"Offer_Company_Positiv"), entOffer.Positivism];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Company_Negativ", @"Offer_Company_Negativ"), entOffer.Negativism];
				}
			}
			else {
				if (entOffer.HumanYn) {
					if ([entOffer.FreelanceYn boolValue])
						[eb appendFormat:@"%@<br /><br />", NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance")];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Human_Positiv", @"Offer_Human_Positiv"), entOffer.Positivism];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Human_Negativ", @"Offer_Human_Negativ"), entOffer.Negativism];
				}
				else {
					if ([entOffer.FreelanceYn boolValue])
						[eb appendFormat:@"%@<br /><br />", NSLocalizedString(@"Offer_Freelance", @"Offer_Freelance")];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Company_Positiv", @"Offer_Company_Positiv"), entOffer.Positivism];
					[eb appendFormat:@"<b>%@</b> %@<br /><br />", NSLocalizedString(@"Offer_Company_Negativ", @"Offer_Company_Negativ"), entOffer.Negativism];
				}
			}
			[eb appendFormat:@"<br /><br /> Sent from BombaJob ..."];
			
			[mailController setMessageBody:eb isHTML:YES];
			[mailController.navigationBar setBarStyle:UIBarStyleBlack];
			[self presentModalViewController:mailController animated:YES];
			[mailController release];
			[eb release];
		}
		else {
			[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Error.InAppEmailCantSend", @"Error.InAppEmailCantSend")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
			alert.tag = 2;
			[alert show];
			[alert release];
		}
	}
	else
		[self showEmailBox];
}

- (void)sendEmailMessageFinished:(id)sender {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Offer_EmailSent", @"Offer_EmailSent")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
	alert.tag = 5;
	[alert show];
	[alert release];
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
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Error.InAppEmailCantSend", @"Error.InAppEmailCantSend")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
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
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:@"..." delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
			alert.tag = 1;
			[alert show];
			[alert release];
			break;
		}
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Twitter

- (IBAction)sendTwitter:(id)sender {
	if (_twitterEngine)
		return;
	_twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_twitterEngine.consumerKey = [bSettings sharedbSettings].twitterOAuthConsumerKey;
	_twitterEngine.consumerSecret = [bSettings sharedbSettings].twitterOAuthConsumerSecret;
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_twitterEngine delegate:self];
	if (controller) 
		[self presentModalViewController:controller animated:YES];
	else
		[self twitterPost];
}

- (void)twitterPost {
	NSMutableString *twitterMessage = [[NSMutableString alloc] init];
	[twitterMessage setString:@"BombaJob.bg - "];
	[twitterMessage appendFormat:@"%@ : ", ((searchOffer == nil) ? entOffer.Title : searchOffer.Title)];
	[twitterMessage appendFormat:@"http://bombajob.bg/offer/%i", ((searchOffer == nil) ? [entOffer.OfferID intValue] : searchOffer.OfferID)];
	[twitterMessage appendFormat:@" #bombajobbg"];
	[_twitterEngine sendUpdate:twitterMessage];
	[twitterMessage release];
}

- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username {
	[[bSettings sharedbSettings] LogThis:@"Authenicated for %@", username];
	[self twitterPost];
}

- (void)OAuthTwitterControllerFailed:(SA_OAuthTwitterController *)controller {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Twitter.LoginError", @"Twitter.LoginError")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
	alert.tag = 891;
	[alert show];
	[alert release];
}

- (void)OAuthTwitterControllerCanceled:(SA_OAuthTwitterController *)controller {
	[[bSettings sharedbSettings] LogThis:@"Twitter Authentication Canceled."];
}

- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:data forKey:@"twitterAuthData"];
	[defaults synchronize];
}

- (NSString *)cachedTwitterOAuthDataForUsername:(NSString *)username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuthData"];
}

- (void)requestSucceeded: (NSString *) requestIdentifier {
	[[bSettings sharedbSettings] LogThis:@"Request %@ succeeded", requestIdentifier];
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Twitter.PublishOK", @"Twitter.PublishOK")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
	alert.tag = 899;
	[alert show];
	[alert release];
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
	[[bSettings sharedbSettings] LogThis:@"Request %@ failed with error: %@", requestIdentifier, [error localizedDescription]];
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Twitter.PublishError", @"Twitter.PublishError"), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
	alert.tag = 898;
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Facebook

- (IBAction)sendFacebook:(id)sender {
    facebookPostSuccess = FALSE;
    if (![[bSettings sharedbSettings]._facebookEngine isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_stream", nil];
        [[bSettings sharedbSettings]._facebookEngine authorize:permissions];
        [permissions release];
    }
    else {
        SBJSON *jsonWriter = [[SBJSON new] autorelease];

        NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          @"BombaJob.bg",@"name",@"http://www.bombajob.bg/", @"link", nil], nil];
        NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       ((searchOffer == nil) ? entOffer.Title : searchOffer.Title), @"name",
                                       [[bSettings sharedbSettings] stripHTMLtags:((searchOffer == nil) ? entOffer.Positivism : searchOffer.Positivism)], @"caption",
                                       [[bSettings sharedbSettings] stripHTMLtags:((searchOffer == nil) ? entOffer.Negativism : searchOffer.Negativism)], @"description",
                                       [NSString stringWithFormat:@"http://bombajob.bg/offer/%i", ((searchOffer == nil) ? [entOffer.OfferID intValue] : searchOffer.OfferID)], @"link",
                                       actionLinksStr, @"actions",
                                       nil];

        [[bSettings sharedbSettings]._facebookEngine dialog:@"feed" andParams:params andDelegate:self];
    }
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[bSettings sharedbSettings]._facebookEngine accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[[bSettings sharedbSettings]._facebookEngine expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    [[bSettings sharedbSettings] LogThis:@"Facebook error %@", [[error userInfo] objectForKey:@"error_msg"]];
    if (!facebookPostSuccess) {
        [BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Facebook.PublishError", @"Facebook.PublishError"), [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
        alert.tag = 792;
        [alert show];
        [alert release];
    }
}

- (void)dialogCompleteWithUrl:(NSURL *)url {
    if (![url query]) {
        [[bSettings sharedbSettings] LogThis:@"Facebook - User canceled dialog or there was an error"];
        return;
    }

    NSDictionary *params = [self parseFacebookURL:[url query]];
    if ([params valueForKey:@"post_id"]) {
        facebookPostSuccess = TRUE;
        [[bSettings sharedbSettings] LogThis:@"Facebook - Published feed successfully. Post ID = %@", [params valueForKey:@"post_id"]];
        [BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Facebook.PublishOK", @"Facebook.PublishOK")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
        alert.tag = 791;
        [alert show];
        [alert release];
    }
}

- (NSDictionary *)parseFacebookURL:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

#pragma mark -
#pragma mark Banners

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self layoutForCurrentOrientation:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [self layoutForCurrentOrientation:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    // While the banner is visible, we don't need to tie up Core Location to track the user location
    // so we turn off the map's display of the user location. We'll turn it back on when the ad is dismissed.
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    // Now that the banner is dismissed, we track the user's location again.
}

- (void)layoutForCurrentOrientation:(BOOL)animated {
    CGFloat animationDuration = animated ? 0.2f : 0.0f;
    CGRect contentFrame = self.contentView.bounds;
	CGPoint bannerOrigin = CGPointMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame));
    CGFloat bannerHeight = 0.0f;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
		self.bannerView.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierLandscape != nil) ? ADBannerContentSizeIdentifierLandscape : ADBannerContentSizeIdentifier480x32;
    else
        self.bannerView.currentContentSizeIdentifier = (&ADBannerContentSizeIdentifierPortrait != nil) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifier320x50; 
    bannerHeight = self.bannerView.bounds.size.height;

    if (self.bannerView.bannerLoaded) {
        contentFrame.size.height -= bannerHeight;
		bannerOrigin.y -= bannerHeight;
    }
    else
		bannerOrigin.y += bannerHeight;
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.contentView.frame = contentFrame;
                         [contentView layoutIfNeeded];
                         self.bannerView.frame = CGRectMake(bannerOrigin.x, bannerOrigin.y + 50, self.bannerView.frame.size.width, self.bannerView.frame.size.height);
                     }];
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
	btnEmail = nil;
	[btnEmail release];
	btnFacebook = nil;
	[btnFacebook release];
	btnTwitter = nil;
	[btnTwitter release];
	webService = nil;
	[webService release];
	_twitterEngine = nil;
	[_twitterEngine release];
    bannerView.delegate = nil;
    bannerView = nil;
    [bannerView release];
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
	[btnEmail release];
	[btnFacebook release];
	[btnTwitter release];
    [btnFacebook release];
	[webService release];
	[_twitterEngine release];
    bannerView.delegate = nil;
    [bannerView release];
    [super dealloc];
}

@end
