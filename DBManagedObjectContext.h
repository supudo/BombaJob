//
//  DBManagedObjectContext.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 bombajob.bg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagedObjectContext : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (DBManagedObjectContext *)sharedDBManagedObjectContext;

- (NSManagedObject *)getEntity:(NSString *)entityName predicateString:(NSString *)predicateString;
- (NSManagedObject *)getEntity:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (NSArray *)getEntities:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (NSArray *)getEntities:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)getEntities:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)getEntities:(NSString *)entityName;
- (int)getEntitiesCount:(NSString *)entityName;
- (int)getEntitiesCount:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (BOOL) deleteAllObjects:(NSString *)entityName;
- (BOOL) deleteObjects:(NSString *)entityName predicate:(NSPredicate *)predicate;

- (NSString *)applicationDocumentsDirectory;

@end
