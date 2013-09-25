//
//  About.h
//  BombaJob
//
//  Created by supudo on 7/28/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface About : UIViewController {
	UIWebView *txtAboutText;
	NSURL *clickedURL;
	BOOL alreadyLoaded;
}

@property (nonatomic, strong) IBOutlet UIWebView *txtAboutText;
@property (nonatomic, strong) NSURL *clickedURL;
@property BOOL alreadyLoaded;

@end
