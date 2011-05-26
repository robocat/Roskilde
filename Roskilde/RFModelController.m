//
//  RFModelController.m
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFModelController.h"
#import "RKCoreDataManager.h"
#import "RKSimpleCoreData.h"

static RFModelController *defaultModelController = nil;


@implementation RFModelController

@synthesize coreDataManager;

+ (RFModelController *)defaultModelController {
	if (!defaultModelController) {
		defaultModelController = [[RFModelController alloc] init];
	}
	return defaultModelController;
}

- (id)init {
	if ((self = [super init])) {
		coreDataManager = [[RKCoreDataManager alloc] initWithInitialType:NSSQLiteStoreType modelName:@"Roskilde" dataStoreName:@"Roskilde.sqlite"];
		simpleCoreData = [[RKSimpleCoreData alloc] init];
		[simpleCoreData setManagedObjectModel:[coreDataManager managedObjectModel]];
		[simpleCoreData setManagedObjectContext:[coreDataManager managedObjectContext]];
	}
	return self;
}


#pragma mark -
#pragma mark Common operations

- (id) newEntityWithName:(NSString *)name {
	[self willChangeValueForKey:name];
	id item = [simpleCoreData newObjectInEntityWithName:name values:nil];
	[self didChangeValueForKey:name];
	return item;
}

- (void) deleteEntity:(id)entity {
	if (entity) {
		[[simpleCoreData managedObjectContext] deleteObject:entity];
	}
}

- (void) deleteEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate {
	[self willChangeValueForKey:name];
	[simpleCoreData deleteEntityWithName:name predicate:predicate];
	[self didChangeValueForKey:name];
}

- (void) deleteAllEntitiesWithName:(NSString *)name {
	[self willChangeValueForKey:name];
	[simpleCoreData deleteAllEntitiesWithName:name];
	[self didChangeValueForKey:name];
}

- (void) save {
	// Commit the change.
	NSError *error = nil;
	if (![coreDataManager save:&error]) {
		// Handle the error.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		[[coreDataManager managedObjectContext] rollback];
	}
}





- (NSArray *)musicSortedByDate {
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"beginDate" ascending:YES] autorelease];
	return [simpleCoreData objectsInEntityWithName:@"Music" predicate:nil sortedWithDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (NSArray *)musicSortedByArtist {
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"artist" ascending:YES] autorelease];
	return [simpleCoreData objectsInEntityWithName:@"Music" predicate:nil sortedWithDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (NSArray *)favoritesSortedByDate {
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"beginDate" ascending:YES] autorelease];
	return [simpleCoreData objectsInEntityWithName:@"Music" predicate:nil sortedWithDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

- (RFMusic *) newMusic {
	[self willChangeValueForKey:@"music"];
	RFMusic *music = (RFMusic *)[simpleCoreData newObjectInEntityWithName:@"Music" values:nil];
	[self didChangeValueForKey:@"music"];
	return music;
}


- (void)deleteMusic:(RFMusic *)music {
	[self willChangeValueForKey:@"music"];
	[[simpleCoreData managedObjectContext] deleteObject:music];
	[self didChangeValueForKey:@"music"];
}


- (void)deleteAllMusic {
	[simpleCoreData deleteAllEntitiesWithName:@"Music"];
}


@end
