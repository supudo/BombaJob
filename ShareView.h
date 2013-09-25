//
//  BlackAlertView.h
//  bombajob.bg
//
//  Created by supudo on 25/9/2013.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SharingOptions {
    SharingOptionsFacebook,
    SharingOptionsTwitter,
    SharingOptionsGooglePlus,
    SharingOptionsTumblr,
    SharingOptionsEmail,
    SharingOptionsSMS
} SharingOptions;

@protocol ShareViewDelegate;

@interface ShareView : UIView <UITableViewDataSource, UITableViewDelegate>

+ (ShareView *)showWithTitle:(NSString *)aTitle withDelegate:(id)del options:(NSArray *)aOptions inView:(UIView *)aView animated:(BOOL)animated;

@end

@protocol ShareViewDelegate <NSObject>
- (void)sharingSelected:(ShareView *)sharingView didSelectedIndex:(NSInteger)sIndex;
- (void)sharingCanceled;
@end