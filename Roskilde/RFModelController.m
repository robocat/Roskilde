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


- (BOOL) hasLocation {
	NSArray *items = [simpleCoreData objectsInEntityWithName:@"Location" predicate:nil sortedWithDescriptors:nil limit:1];
	if ([items count])
		return YES;
	return NO;
}

- (NSArray*)allLocations {
	return [simpleCoreData objectsInEntityWithName:@"Location" predicate:nil sortedWithDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"map" ascending:YES] autorelease]]];
}


- (NSArray*)allLocationsNearCoordinate:(CLLocationCoordinate2D)coordinate {
/*	NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		Location *location = (Location*)evaluatedObject;
		float latDiff = coordinate.latitude - location.latValue;
		float lonDiff = coordinate.longitude - location.lonValue;
		return ((latDiff < 0? -latDiff: latDiff) < 0.001 && (lonDiff < 0? -lonDiff: lonDiff) < 0.001);
	}];*/
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:
						 @"lat > %f and lat < %f and lon > %f and lon < %f",
						 coordinate.latitude - 0.001,
						 coordinate.latitude + 0.001,
						 coordinate.longitude - 0.001,
						 coordinate.longitude + 0.001];
	
	return [simpleCoreData objectsInEntityWithName:@"Location" predicate:pred sortedWithDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"map" ascending:YES] autorelease]]];
}


- (Location*)newLocation {
	[self willChangeValueForKey:@"location"];
	Location *location = (Location*)[simpleCoreData newObjectInEntityWithName:@"Location" values:nil];
	[self didChangeValueForKey:@"music"];
	return location;
}


- (void)deleteLocation:(Location*)location {
	[self willChangeValueForKey:@"location"];
	[[simpleCoreData managedObjectContext] deleteObject:location];
	[self didChangeValueForKey:@"location"];
}


- (BOOL) hasMusic {
	NSArray *items = [simpleCoreData objectsInEntityWithName:@"Music" predicate:nil sortedWithDescriptors:nil limit:1];
	if ([items count])
		return YES;
	return NO;
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
