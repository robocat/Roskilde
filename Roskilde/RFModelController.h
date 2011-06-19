//
//  RFModelController.h
//  Roskilde
//
//  Created by Willi Wu on 23/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFMusic2011.h"
#import "RFLocation.h"
#import <CoreLocation/CoreLocation.h>


@class RKCoreDataManager, RKSimpleCoreData;

@interface RFModelController : NSObject {
	RKCoreDataManager *coreDataManager;
	RKSimpleCoreData *simpleCoreData;
}

+ (RFModelController *)defaultModelController;

@property (readonly) RKCoreDataManager *coreDataManager;


// Common operations

- (id) newEntityWithName:(NSString *)name;
- (void) deleteEntity:(id)entity;
- (void) deleteEntitiesWithName:(NSString *)name predicate:(NSPredicate *)predicate;
- (void) deleteAllEntitiesWithName:(NSString *)name;
- (void) save;


- (BOOL) hasLocation;
- (NSArray*)allLocationsNearCoordinate:(CLLocationCoordinate2D)coordinate;
- (NSArray*)allLocations;
- (RFLocation*)newLocation;
- (void)deleteLocation:(RFLocation*)location;


- (BOOL) hasMusic;
- (NSArray *)musicSortedByDate;
- (NSArray *)musicSortedByArtist;
- (NSArray *)favoritesSortedByDate;

- (RFMusic2011 *) newMusic;

- (void)deleteMusic:(RFMusic2011 *)music;
- (void)deleteAllMusic;

@end
