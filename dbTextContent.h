//
//  dbTextContent.h
//  BombaJob
//
//  Created by supudo on 7/28/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface dbTextContent :  NSManagedObject  
{
}

@property (nonatomic, strong) NSNumber * CID;
@property (nonatomic, strong) NSString * Title;
@property (nonatomic, strong) NSString * Content;

@end



