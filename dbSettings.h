//
//  dbSettings.h
//  BombaJob
//
//  Created by supudo on 7/14/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface dbSettings :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * SName;
@property (nonatomic, strong) NSString * SValue;

@end



