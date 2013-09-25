//
//  DDAlertPrompt.m
//  DDAlertPrompt (Released under MIT License)
//
//  Created by digdog on 10/27/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. http://digdog.tumblr.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//   
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//   
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "DDAlertPrompt.h"
#import <QuartzCore/QuartzCore.h>

@interface DDAlertPrompt () 
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextField *plainTextField1, *plainTextField2;
- (void)orientationDidChange:(NSNotification *)notification;
- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef) context withRadius:(CGFloat) radius;
@end


@implementation DDAlertPrompt

static UIColor *fillColor = nil;
static UIColor *borderColor = nil;

@synthesize tableView = tableView_;
@synthesize plainTextField1 = plainTextField1_;
@synthesize plainTextField2 = plainTextField2_;

+ (void) setBackgroundColor:(UIColor *) background withStrokeColor:(UIColor *) stroke {
	fillColor = background;
	borderColor = stroke;
}

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitles {
	
	if ((self = [super initWithTitle:title message:@"\n\n\n" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil])) {
		// FIXME: This is a workaround. By uncomment below, UITextFields in tableview will show characters when typing (possible keyboard reponder issue).
		[self addSubview:self.plainTextField1];
		
		tableView_ = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
		tableView_.delegate = self;
		tableView_.dataSource = self;		
		tableView_.scrollEnabled = NO;
		tableView_.opaque = NO;
		tableView_.layer.cornerRadius = 3.0f;
		tableView_.editing = YES;
		tableView_.rowHeight = 28.0f;
		[self addSubview:tableView_];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];        
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		
        if (fillColor == nil) {
			fillColor = [UIColor blackColor];
			borderColor = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8];
		}
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[tableView_ setDataSource:nil];
	[tableView_ setDelegate:nil];
}

#pragma mark -
#pragma mark L	ayout

- (void)layoutSubviews {
	for (UIView *sub in [self subviews]) {
		if ([sub class] == [UIImageView class] && sub.tag == 0) {
			[sub removeFromSuperview];
			break;
		}
	}
	// We assume keyboard is on.
	if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
		if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
			self.center = CGPointMake(160.0f, (460.0f - 216.0f)/2 + 12.0f);
			self.tableView.frame = CGRectMake(12.0f, 51.0f, 260.0f, 56.0f);		
		}
		else {
			self.center = CGPointMake(240.0f, (300.0f - 162.0f)/2 + 12.0f);
			self.tableView.frame = CGRectMake(12.0f, 35.0f, 260.0f, 56.0f);		
		}
	}
}

- (void)orientationDidChange:(NSNotification *)notification {
	[self setNeedsLayout];
}

#pragma mark -
#pragma mark Accessors

- (UITextField *)plainTextField1 {
	if (!plainTextField1_) {
		plainTextField1_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		[plainTextField1_ setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[plainTextField1_ setClearButtonMode:UITextFieldViewModeWhileEditing];
		[plainTextField1_ setKeyboardAppearance:UIKeyboardAppearanceAlert];
		[plainTextField1_ setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
		[plainTextField1_ setTextColor:[UIColor blackColor]];
		[plainTextField1_ setBackgroundColor:[UIColor clearColor]];
		[plainTextField1_ setAutocorrectionType:UITextAutocorrectionTypeNo];
		[plainTextField1_ setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[plainTextField1_ setPlaceholder:NSLocalizedString(@"Offer_SentEmailTo", @"Offer_SentEmailTo")];
	}
	return plainTextField1_;
}

- (UITextField *)plainTextField2 {
	if (!plainTextField2_) {
		plainTextField2_ = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, 255.0f, 28.0f)];
		[plainTextField2_ setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[plainTextField2_ setClearButtonMode:UITextFieldViewModeWhileEditing];
		[plainTextField2_ setKeyboardAppearance:UIKeyboardAppearanceAlert];
		[plainTextField2_ setFont:[UIFont fontWithName:@"Ubuntu" size:14.0]];
		[plainTextField2_ setTextColor:[UIColor blackColor]];
		[plainTextField2_ setBackgroundColor:[UIColor clearColor]];
		[plainTextField2_ setAutocorrectionType:UITextAutocorrectionTypeNo];
		[plainTextField2_ setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[plainTextField2_ setPlaceholder:NSLocalizedString(@"Offer_SentEmailFrom", @"Offer_SentEmailFrom")];
		if ([bSettings sharedbSettings].stPrivateData) {
			[plainTextField2_ setText:[[bSettings sharedbSettings] getSetting:@"Email"]];
			[plainTextField2_ setText:[plainTextField2_.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
			[plainTextField2_ setText:[plainTextField2_.text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]];
		}
	}
	return plainTextField2_;
}

#pragma mark -
#pragma mark Table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *AlertPromptCellIdentifier = @"DDAlertPromptCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:AlertPromptCellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AlertPromptCellIdentifier];
	if (![cell.contentView.subviews count]) {
		if (indexPath.row)
			[cell.contentView addSubview:self.plainTextField2];			
		else
			[cell.contentView addSubview:self.plainTextField1];
	}
    return cell;	
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(context, rect);
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetLineWidth(context, 0.0);
	CGContextSetAlpha(context, 0.8); 
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
	
	// Draw background
	CGFloat backOffset = 2;
	CGRect backRect = CGRectMake(rect.origin.x + backOffset, rect.origin.y + backOffset, rect.size.width - backOffset*2, rect.size.height - backOffset*2);
	[self drawRoundedRect:backRect inContext:context withRadius:8];
	CGContextDrawPath(context, kCGPathFillStroke);
	
	// Clip Context
	CGRect clipRect = CGRectMake(backRect.origin.x + backOffset - 1, backRect.origin.y + backOffset - 1, backRect.size.width - (backOffset - 1) * 2, backRect.size.height - (backOffset - 1) * 2);
	[self drawRoundedRect:clipRect inContext:context withRadius:8];
	CGContextClip (context);

	//Draw highlight
	CGGradientRef glossGradient;
	CGColorSpaceRef rgbColorspace;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 1.0 };
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35, 1.0, 1.0, 1.0, 0.06 };
	rgbColorspace = CGColorSpaceCreateDeviceRGB();
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
	CGRect ovalRect = CGRectMake(-130, -115, (rect.size.width * 2), rect.size.width / 2);
	
	CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
	CGPoint end = CGPointMake(rect.origin.x, rect.size.height / 5);
	
	CGContextSetAlpha(context, 1.0); 
	CGContextAddEllipseInRect(context, ovalRect);
	CGContextClip (context);
	
	CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
	
	CGGradientRelease(glossGradient);
	CGColorSpaceRelease(rgbColorspace); 
}

- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context withRadius:(CGFloat) radius {
	CGContextBeginPath (context);
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}

@end
