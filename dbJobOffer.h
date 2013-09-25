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

@property (nonatomic, strong) NSNumber * OfferID;
@property (nonatomic, strong) NSString * Positivism;
@property (nonatomic, strong) NSNumber * CategoryID;
@property (nonatomic, strong) NSString * Title;
@property (nonatomic, strong) NSString * Negativism;
@property (nonatomic, strong) NSString * CategoryTitle;
@property (nonatomic, strong) NSDate * PublishDate;
@property (nonatomic, strong) dbCategory * category;
@property (nonatomic, strong) NSNumber * HumanYn;
@property (nonatomic, strong) NSNumber * FreelanceYn;
@property (nonatomic, strong) NSString * Email;
@property (nonatomic, strong) NSNumber * ReadYn;
@property (nonatomic, strong) NSNumber * SentMessageYn;

@end



