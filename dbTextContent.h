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

@property (nonatomic, retain) NSNumber * CID;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * Content;

@end



