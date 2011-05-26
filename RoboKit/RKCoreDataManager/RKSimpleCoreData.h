//
//  RKSimpleCoreData.h
//  Outside
//
//  Created by Willi Wu on 18/03/10.
//  Copyright 2010 Robocat. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 @class RKSimpleCoreData
 @discussion This class provides a simpler interface to the more common functions in Core Data,
 handling the mundane tasks like creating fetch requests and letting you focus on deciding what
 data you want and how you want it
 */
@interface RKSimpleCoreData : NSObject {
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
}

@property (retain) NSManagedObjectModel *managedObjectModel;
@property (retain) NSManagedObjectContext *managedObjectContext;

/**
 @abstract Returns objects in the entity with the supplied name, filtered by the predicate and sorted with the descriptors
 @param name The name of the entity to return objects from
 @param pred The predicate with which to filter the objects
 @param descriptors An array of NSSortDescriptors
 @result An array of NSManagedObjects matching the predicate in the enitty with the supplied name
 */
- (NSArray *)objectsInEntityWithName:(NSString *)name predicate:(NSPredicate *)pred sortedWithDescriptors:(NSArray *)descriptors;


// With limit // Limit 0 fetches all
- (NSArray *)objectsInEntityWithName:(NSString *)name
						   predicate:(NSPredicate *)pred
			   sortedWithDescriptors:(NSArray *)descriptors
							   limit:(NSUInteger)limit;


/**
 @abstract Creates and returns a new managed object in the entity with the supplied name with default values from the supplied dictionary
 @param name The name of the enitty to return objects from
 @param values A dictionary containing key value pairs to set in the managed object. The keys of the dictionary must match values in the model
 @result The newly created NSMangagedObject
 */
- (NSManagedObject *)newObjectInEntityWithName:(NSString *)name values:(NSDictionary *)values;


// Delete an entity with a predicate
- (void)deleteEntityWithName:(NSString *)name predicate:(NSPredicate *)pred;


// Delete all entities
- (void)deleteAllEntitiesWithName:(NSString *)name;

@end
