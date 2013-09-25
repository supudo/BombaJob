//
//  ShareViewCell.m
//  bombajob.bg
//
//  Created by supudo on 25/9/2013.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import "ShareViewCell.h"

@implementation ShareViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"Verdana" size:16];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectOffset(self.imageView.frame, 6, 0);
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 6, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
