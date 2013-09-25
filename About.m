//
//  About.m
//  BombaJob
//
//  Created by supudo on 7/27/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import "About.h"
#import "DBManagedObjectContext.h"
#import "dbTextContent.h"
#import "BlackAlertView.h"

@implementation About

@synthesize txtAboutText, clickedURL, alreadyLoaded;

#pragma mark -
#pragma mark Work

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"About", @"About");
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-pattern.png"]];
	dbTextContent *tc = (dbTextContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"TextContent" predicate:[NSPredicate predicateWithFormat:@"CID=%@", @"35"]];

	alreadyLoaded = FALSE;
	NSMutableString *txt = [[NSMutableString alloc] init];
	[txt setString:@""];
	[txt appendString:[NSString stringWithFormat:@"<html><style>html,body {font-family: Ubuntu; font-size: 16px; color: #000000; margin: 0px; padding: 0px;} a {color: #000000; text-decoration: underline;} </style><body><div style=\"padding: 10px; width: 295px;\">"]];
	[txt appendString:tc.Content];
    [txt appendString:@"<br /><br /><br /><a href=\"http://m.bombajob.bg/\">BombaJob.bg</a>"];
	[txt appendString:@"</div></body></html>"];
	[txtAboutText loadHTMLString:txt baseURL:nil];
	[txtAboutText setBackgroundColor:[UIColor clearColor]];
	[txtAboutText setOpaque:NO];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	if (alreadyLoaded) {
		self.clickedURL = [request URL];
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ExternalURLWarning", @"ExternalURLWarning") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.NO", @"UI.NO") otherButtonTitles:NSLocalizedString(@"UI.YES", @"UI.YES"), nil];
		[alert show];
		return NO;
	}
	else {
		alreadyLoaded = TRUE;
		return YES;
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1 && self.clickedURL != nil)
		[[UIApplication sharedApplication] openURL:self.clickedURL];
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
	txtAboutText = nil;
	clickedURL = nil;
    [super viewDidUnload];
}


@end
