//
//  dbJobOffer.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <CoreData/CoreData.h>

@class dbCategory;

@interface dbJobOffer :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * OfferID;
@property (nonatomic, retain) NSString * Positivism;
@property (nonatomic, retain) NSNumber * CategoryID;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * Negativism;
@property (nonatomic, retain) NSString * CategoryTitle;
@property (nonatomic, retain) NSDate * PublishDate;
@property (nonatomic, retain) dbCategory * category;
@property (nonatomic, retain) NSNumber * HumanYn;
@property (nonatomic, retain) NSNumber * FreelanceYn;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSNumber * ReadYn;
@property (nonatomic, retain) NSNumber * SentMessageYn;

@end



