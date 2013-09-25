//
//  ShareView.h
//  bombajob.bg
//
//  Created by supudo on 25/9/2013.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import "ShareView.h"
#import "ShareViewCell.h"

#define SV_SCREEN_MARGIN 40.
#define SV_SCREEN_MARGIN_LANDSCAPE 100.
#define SV_HEADER_HEIGHT 50.
#define RADIUS 5.

static NSString *shareViewCellIdentifier = @"shareViewCell";

@interface ShareView ()
@property (nonatomic, weak) id<ShareViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tblItems;
@property (nonatomic, strong) NSString *viewTitle;
@property (nonatomic, strong) NSArray *sharingItems;
@property float screenMargin;

- (void)fadeIn;
- (void)fadeOut;
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)hideView;
@end

@implementation ShareView

@synthesize delegate, tblItems, viewTitle, sharingItems, screenMargin;

static ShareView *currentSharingView = nil;

#pragma mark -
#pragma mark Init

+ (ShareView *)showWithTitle:(NSString *)aTitle withDelegate:(id)del options:(NSArray *)aOptions inView:(UIView *)aView animated:(BOOL)animated {
    if (currentSharingView)
        [currentSharingView fadeOut];
    currentSharingView = [[ShareView alloc] initWithTitle:aTitle options:aOptions];
    [currentSharingView setDelegate:del];
    [currentSharingView showInView:aView animated:animated];
    return currentSharingView;
}

#pragma mark -
#pragma mark Methods

- (id)initWithTitle:(NSString *)title options:(NSArray *)items {
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    screenMargin = SV_SCREEN_MARGIN;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        rect.size.width = [[UIScreen mainScreen] applicationFrame].size.height;
        rect.size.height = [[UIScreen mainScreen] applicationFrame].size.width;
        screenMargin = SV_SCREEN_MARGIN_LANDSCAPE;
    }
    
    if (self = [super initWithFrame:rect]) {
        self.backgroundColor = [UIColor clearColor];
        viewTitle = [title copy];
        sharingItems = [items copy];
        float tblHeight = ([sharingItems count] * 44 + RADIUS);
        float tblY = SV_HEADER_HEIGHT + (rect.size.height - ([sharingItems count] * 44 + SV_HEADER_HEIGHT + RADIUS)) / 2;
        tblItems = [[UITableView alloc] initWithFrame:CGRectMake(screenMargin,
                                                                 tblY,
                                                                 rect.size.width - 2 * screenMargin,
                                                                 tblHeight)];
        tblItems.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        tblItems.backgroundColor = [UIColor clearColor];
        tblItems.dataSource = self;
        tblItems.delegate = self;
        tblItems.separatorStyle = UITableViewStylePlain;
        tblItems.bounces = NO;
        [self addSubview:tblItems];
    }
    return self;
}

- (void)hideView {
}

- (void)fadeIn {
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut {
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
            [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated {
    [aView addSubview:self];
    if (animated)
        [self fadeIn];
}

#pragma mark -
#pragma mark Table delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [sharingItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shareViewCellIdentifier];
    if (cell == nil) {
        cell = [[ShareViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.imageView.image = [[sharingItems objectAtIndex:[indexPath row]] objectAtIndex:0];
    cell.textLabel.text = NSLocalizedString([[sharingItems objectAtIndex:[indexPath row]] objectAtIndex:1], @"<share>");
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharingSelected:didSelectedIndex:)])
        [self.delegate sharingSelected:self didSelectedIndex:[indexPath row]];
    [self fadeOut];
}

#pragma mark -
#pragma mark Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharingCanceled)])
        [self.delegate sharingCanceled];
    [self fadeOut];
}

#pragma mark -
#pragma mark Draw

- (void)drawRect:(CGRect)rect {
    //CGRect bgRect = CGRectInset(rect, SV_SCREEN_MARGIN, SV_SCREEN_MARGIN);
    float bgHeight = ([sharingItems count] * 44 + SV_HEADER_HEIGHT + RADIUS);
    if (bgHeight > rect.size.height)
        bgHeight = rect.size.height -  44;

    float bgY = (rect.size.height - bgHeight) / 2;
    CGRect bgRect = CGRectMake(rect.origin.x, bgY, (rect.size.width - (screenMargin * 2)), bgHeight);

    //float titleY = SV_SCREEN_MARGIN + 10 + 5;
    float titleY = bgY + 15;
    CGRect titleRect = CGRectMake(screenMargin + 10, titleY, rect.size.width - 2 * (screenMargin + 10), 30);

    float sepY = screenMargin + SV_HEADER_HEIGHT - 2;
    sepY = bgY + SV_HEADER_HEIGHT - 2;
    CGRect separatorRect = CGRectMake(screenMargin, sepY, rect.size.width - 2 * screenMargin, 2);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:.75].CGColor);
    [[UIColor colorWithWhite:0 alpha:.75] setFill];
    
    float x = screenMargin;
    float y = bgY;//(rect.size.height - bgRectHeight) / 2;//SV_SCREEN_MARGIN;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, y + RADIUS);
    CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
    CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
    CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
    CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);

    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.] setFill];
    [viewTitle drawInRect:titleRect withFont:[UIFont fontWithName:@"Verdana-Bold" size:18]];
    CGContextFillRect(ctx, separatorRect);
}

#pragma mark -
#pragma mark System


@end