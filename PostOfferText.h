//
//  PostOfferText.h
//  BombaJob
//
//  Created by supudo on 7/14/11.
//  Copyright 2011 BombaJob.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostOfferText : UIViewController <UITextViewDelegate> {
	UITextView *txtDesc;
	int descID;
}

@property (nonatomic, retain) IBOutlet UITextView *txtDesc;
@property int descID;

@end
