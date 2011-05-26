//
//  RKCoreDataManager.h
//  Outside
//
//  Created by Willi Wu on 18/03/10.
//  Copyright 2010 Robocat. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface RKCoreDataManager : NSObject {
	NSString *initialType;
	NSString *modelName;
	NSString *dataStoreName;
	
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	
}

- (id)initWithInitialType:(NSString *)type modelName:(NSString *)mName dataStoreName:(NSString *)storeName;

- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (BOOL)save:(NSError **)error;

@end
