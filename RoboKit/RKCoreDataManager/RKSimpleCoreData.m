//
//  RKSimpleCoreData.m
//  Outside
//
//  Created by Willi Wu on 18/03/10.
//  Copyright 2010 Robocat. All rights reserved.
//

#import "RKSimpleCoreData.h"


@implementation RKSimpleCoreData

@synthesize managedObjectModel;
@synthesize managedObjectContext;


- (NSArray *)objectsInEntityWithName:(NSString *)name
						   predicate:(NSPredicate *)pred
			   sortedWithDescriptors:(NSArray *)descriptors
							   limit:(NSUInteger)limit {
	//Check the required variables are set
	if (!managedObjectModel || !managedObjectContext || !name) {
		return nil;
	}
	
	NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:name];
	
	//If our entity doesn't exist return nil
	if (!entity) {
		NSLog(@"entity doesn't exist in entities:%@", [managedObjectModel entitiesByName]);
		return nil;
	}
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	[request setEntity:entity];
	[request setPredicate:pred];
	[request setSortDescriptors:descriptors];
	
	if (limit > 0) {
		[request setFetchLimit:limit];
	}
	
	NSError *error = nil;
	NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	
	//If there was an error then return nothing
	if (error) {
		NSLog(@"error:%@", error);
		return nil;
	}
	
	return results;
}

- (NSArray *)objectsInEntityWithName:(NSString *)name predicate:(NSPredicate *)pred sortedWithDescriptors:(NSArray *)descriptors {
	NSArray * results = [self objectsInEntityWithName:name
											predicate:pred
								sortedWithDescriptors:descriptors
												limit:0];
	return results;
}
	
- (NSManagedObject *)newObjectInEntityWithName:(NSString *)name values:(NSDictionary *)values {
	//Check the required variables are set
	if (!managedObjectModel || !managedObjectContext || !name) {
		return nil;
	}
	
	NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:name];
	
	//If our entity doesn't exist return nil
	if (!entity) {
		return nil;
	}
	
	NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
	
	if (!object) {
		return nil;
	}
	
	for (NSString *key in [values allKeys]) {
		[object setValue:[values objectForKey:key] forKey:key];
	}
	return object;
}


- (void)deleteEntityWithName:(NSString *)name predicate:(NSPredicate *)pred {
	//Check the required variables are set
	if (!managedObjectModel || !managedObjectContext || !name) {
		return;
	}
	
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:managedObjectContext]];
	[request setPredicate:pred];
	
	NSError * error = nil;
	NSArray * results = [managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	
	//error handling goes here
	for (NSManagedObject * obj in results) {
		[managedObjectContext deleteObject:obj];
	}
}

- (void)deleteAllEntitiesWithName:(NSString *)name {
	//Check the required variables are set
	if (!managedObjectModel || !managedObjectContext || !name) {
		return;
	}
	
	NSFetchRequest * request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:name inManagedObjectContext:managedObjectContext]];
	
	NSError * error = nil;
	NSArray * results = [managedObjectContext executeFetchRequest:request error:&error];
	[request release];
	
	//error handling goes here
	for (NSManagedObject * obj in results) {
		[managedObjectContext deleteObject:obj];
	}
}

@end
