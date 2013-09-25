//
//  CurrentOffer.h
//  BombaJob
//
//  Created by supudo on 7/14/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentOffer : NSObject {
	int OfferID, CategoryID;
	BOOL HumanYn, FreelanceYn;
	NSString *Title, *Email, *Positivism, *Negativism, *CategoryTitle;
	NSDate *PublishDate;
}

@property int OfferID, CategoryID;
@property BOOL HumanYn, FreelanceYn;
@property (nonatomic, strong) NSString *Title, *Email, *Positivism, *Negativism, *CategoryTitle;
@property (nonatomic, strong) NSDate *PublishDate;

- (void)clearAll;

@end
