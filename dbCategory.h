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

@property (nonatomic, strong) NSNumber * CategoryID;
@property (nonatomic, strong) NSString * CategoryTitle;
@property (nonatomic, strong) NSSet* offers;
@property (nonatomic, strong) NSNumber * OffersCount;

@end


@interface dbCategory (CoreDataGeneratedAccessors)
- (void)addOffersObject:(dbJobOffer *)value;
- (void)removeOffersObject:(dbJobOffer *)value;
- (void)addOffers:(NSSet *)value;
- (void)removeOffers:(NSSet *)value;

@end

