//
//  dbCategory.h
//  BombaJob
//
//  Created by supudo on 7/4/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <CoreData/CoreData.h>

@class dbJobOffer;

@interface dbCategory :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * CategoryID;
@property (nonatomic, retain) NSString * CategoryTitle;
@property (nonatomic, retain) NSSet* offers;
@property (nonatomic, retain) NSNumber * OffersCount;

@end


@interface dbCategory (CoreDataGeneratedAccessors)
- (void)addOffersObject:(dbJobOffer *)value;
- (void)removeOffersObject:(dbJobOffer *)value;
- (void)addOffers:(NSSet *)value;
- (void)removeOffers:(NSSet *)value;

@end

