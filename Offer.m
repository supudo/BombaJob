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
#import "DDAlertPrompt.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

#define kOFFSET_FOR_KEYBOARD 60.0

@implementation Offer

@synthesize entOffer, searchOffer;
@synthesize scrollView, contentView, bannerView;
@synthesize txtCategory, txtTitle, txtPositivism, txtNegativism;
@synthesize lblDate, lblFreelance, lblLPositiv, lblLNegativ;
@synthesize btnEmail, btnTwitter, btnFacebook, webService;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	if (entOffer == nil)
		self.navigationItem.title = searchOffer.Title;
	else
		self.navigationItem.title = entOffer.Title;
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openSharingView)];
    if (webService == nil)
		webService = [[WebService alloc] init];
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
	txtView.contentInset = UIEdgeInsetsZero;

    CGSize maximumSize = CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT);
    CGSize s = [txt sizeWithFont:txtView.font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
	[txtView setFrame:(CGRect){txtView.frame.origin, maximumSize.width, s.height + 20}];
}

- (void)doDesign {
	[lblDate setFont:[UIFont fontWithName:@"Ubuntu-Italic" size:14]];
	[txtTitle setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[lblLPositiv setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[lblLNegativ setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[txtPositivism setDataDetectorTypes:UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber];
	[txtNegativism setDataDetectorTypes:UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber];

	[btnEmail.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[[bSettings sharedbSettings] roundButtonCorners:btnEmail withColor:[UIColor blackColor]];
	[btnFacebook.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[[bSettings sharedbSettings] roundButtonCorners:btnFacebook withColor:[UIColor blackColor]];
	[btnTwitter.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:14]];
	[[bSettings sharedbSettings] roundButtonCorners:btnTwitter withColor:[UIColor blackColor]];

    float x = 10;
    float y = 10;
    [txtCategory setFrame:(CGRect){x, y, txtCategory.frame.size}];
    
    y = txtCategory.frame.origin.y + txtCategory.frame.size.height + 10;
    [txtTitle setFrame:(CGRect){x, y, txtTitle.frame.size}];
    
    y = txtTitle.frame.origin.y + txtTitle.frame.size.height + 10;
    [lblDate setFrame:(CGRect){x, y, lblDate.frame.size}];
    
    y = lblDate.frame.origin.y + lblDate.frame.size.height + 10;
    if (!lblFreelance.hidden) {
        [lblFreelance setFrame:(CGRect){x, y, lblFreelance.frame.size}];
        y = lblFreelance.frame.origin.y + lblFreelance.frame.size.height + 10;
    }
    
    [lblLPositiv setFrame:(CGRect){x, y, lblLPositiv.frame.size}];
    
    y = lblLPositiv.frame.origin.y + lblLPositiv.frame.size.height + 10;
    [txtPositivism setFrame:(CGRect){x, y, txtPositivism.frame.size}];
    
    y = txtPositivism.frame.origin.y + txtPositivism.frame.size.height + 10;
    [lblLNegativ setFrame:(CGRect){x, y, lblLNegativ.frame.size}];
    
    y = lblLNegativ.frame.origin.y + lblLNegativ.frame.size.height + 10;
    [txtNegativism setFrame:(CGRect){x, y, txtNegativism.frame.size}];

    float h = txtNegativism.frame.origin.y + txtNegativism.frame.size.height + 10;
	[contentView setFrame:(CGRect){contentView.frame.origin, self.view.frame.size.width, h}];
	[scrollView setContentSize:(CGSize){self.view.frame.size.width, h}];
}

- (void)showBanner {
    if ([bSettings sharedbSettings].stShowBanners)
        [self layoutForCurrentOrientation:NO];
    else
        self.bannerView.hidden = YES;
}

#pragma mark -
#pragma mark Sharing

- (void)openSharingView {
    NSArray *sharingOptions = [NSArray arrayWithObjects:
                              [NSArray arrayWithObjects:[UIImage imageNamed:@"btn-facebook.png"], @"SocNet.Nets.Facebook", [NSNumber numberWithInt:0], nil],
                              [NSArray arrayWithObjects:[UIImage imageNamed:@"btn-twitter.png"], @"SocNet.Nets.Twitter", [NSNumber numberWithInt:1], nil],
                              [NSArray arrayWithObjects:[UIImage imageNamed:@"btn-email.png"], @"SocNet.Nets.Email", [NSNumber numberWithInt:2], nil],
                              [NSArray arrayWithObjects:[UIImage imageNamed:@"btn-message.png"], @"SocNet.Nets.Message", [NSNumber numberWithInt:3], nil],
                              nil];

    [ShareView showWithTitle:NSLocalizedString(@"SocNet.ShareThis", @"SocNet.ShareThis") withDelegate:self options:sharingOptions inView:self.view animated:YES];
}

- (void)sharingSelected:(ShareView *)sharingView didSelectedIndex:(NSInteger)sIndex {
    switch (sIndex) {
        case 0:
            [self sendFacebook:nil];
            break;
        case 1:
            [self sendTwitter:nil];
            break;
        case 2:
            [self sendEmail:nil];
            break;
        case 3:
            [self sendMessage];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Email

- (void)showEmailBox {
	DDAlertPrompt *emailAlert = [[DDAlertPrompt alloc] initWithTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Offer_EmailEnterYourEmail", @"Offer_EmailEnterYourEmail")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.Cancel", @"UI.Cancel") otherButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK")];	
	emailAlert.tag = 3;
	[emailAlert show];
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
			[self presentViewController:mailController animated:YES completion:nil];
		}
		else {
			[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Error.InAppEmailCantSend", @"Error.InAppEmailCantSend")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
			alert.tag = 2;
			[alert show];
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
			[self presentViewController:mailController animated:YES completion:nil];
		}
		else {
			[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
			BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Error.InAppEmailCantSend", @"Error.InAppEmailCantSend")] delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
			alert.tag = 1;
			[alert show];
		}
	}
	else {
		OfferMessage *tvc = [[OfferMessage alloc] initWithNibName:@"OfferMessage" bundle:nil];
		if (searchOffer == nil)
			tvc.entOffer = entOffer;
		else
			tvc.searchOffer = searchOffer;
		[[self navigationController] pushViewController:tvc animated:YES];
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
			break;
		}
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Twitter

- (IBAction)sendTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSMutableString *twitterMessage = [[NSMutableString alloc] init];
        [twitterMessage setString:@"BombaJob.bg - "];
        [twitterMessage appendFormat:@"%@ : ", ((searchOffer == nil) ? entOffer.Title : searchOffer.Title)];
        [twitterMessage appendFormat:@"http://bombajob.bg/offer/%i", ((searchOffer == nil) ? [entOffer.OfferID intValue] : searchOffer.OfferID)];
        [twitterMessage appendFormat:@" #bombajobbg"];

        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:twitterMessage];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        [BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"SocNet.Message.Twitter.Error", @"SocNet.Message.Twitter.Error") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
    }
}

#pragma mark -
#pragma mark Facebook

- (IBAction)sendFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSMutableString *facebookMessage = [[NSMutableString alloc] init];
        [facebookMessage setString:@"BombaJob.bg\n"];
        [facebookMessage appendFormat:@"%@\n", ((searchOffer == nil) ? entOffer.Title : searchOffer.Title)];
        [facebookMessage appendFormat:@"http://bombajob.bg/offer/%i\n", ((searchOffer == nil) ? [entOffer.OfferID intValue] : searchOffer.OfferID)];
        [facebookMessage appendFormat:@"%@", ((searchOffer == nil) ? entOffer.Positivism : searchOffer.Positivism)];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:facebookMessage];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        [BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"SocNet.Message.Facebook.Error", @"SocNet.Message.Twitter.Error") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
    }
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
	searchOffer = nil;
	scrollView = nil;
	contentView = nil;
	txtCategory = nil;
	txtTitle = nil;
	txtPositivism = nil;
	txtNegativism = nil;
	lblDate = nil;
	lblFreelance = nil;
	lblLPositiv = nil;
	lblLNegativ = nil;
	btnEmail = nil;
	btnFacebook = nil;
	btnTwitter = nil;
	webService = nil;
    bannerView.delegate = nil;
    bannerView = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    bannerView.delegate = nil;
}

@end
