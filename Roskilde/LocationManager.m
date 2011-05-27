//
//  LocationManager.m
//  Roskilde
//
//  Created by Ulrik Damm on 5/27/11.
//  Copyright 2011 Gereen.dk. All rights reserved.
//

#import "LocationManager.h"
#import "RFModelController.h"
#import "JSONKit.h"

@implementation LocationManager

- (id)init {
	[NSException raise:@"don't do that" format:@"LocationManager can't be initialized"];
	return nil;
}


+ (void)loadLocationData {
	dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
		RFModelController *model = [RFModelController defaultModelController];
		
		for (Location *location in [model allLocations]) {
			[model deleteLocation:location];
		}
		
		if ([[model allLocations] count] == 0) {
			NSError *error = nil;
			NSString *json = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"festival" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
			
			if (error) {
				[NSException raise:@"could not load festival.json" format:@"error: %@", [error localizedDescription]];
				return;
			}
			
			NSArray *objects = (NSArray*)[json objectFromJSONString];
			
			
			for (NSDictionary *dict in objects) {
				Location *location = [model newLocation];
				[location setLatValue:[[dict valueForKey:@"lat"] floatValue]];
				[location setLonValue:[[dict valueForKey:@"lon"] floatValue]];
				location.area = [dict valueForKey:@"area"];
				location.name = [dict valueForKey:@"name"];
				location.map = [dict valueForKey:@"map"];
				location.type = [dict valueForKey:@"type"];
				
				if ([location.type isEqualToString:@"camp_area"]) {
					location.name = [NSString stringWithFormat:@"Camp area %@", location.name];
				}
			}
			
			[model save];
		}
	});
}


+ (NSArray*)locationObjectsForPosition:(CLLocationCoordinate2D)coordinate nearest:(Location**)nearest {
	NSArray *nearLocations = [[RFModelController defaultModelController] allLocationsNearCoordinate:coordinate];
	
	if ([nearLocations count] == 1) {
		return [nearLocations objectAtIndex:0];
	}
	
	if ([nearLocations count] == 0) {
		return nil;
	}
	
	float nearestDistance = 0.01;
	Location *nearestLocation = nil;
	
	for (Location *location in nearLocations) {
		float distance = sqrtf(powf(location.latValue - coordinate.latitude, 2) + powf(location.lonValue - coordinate.longitude, 2));
		if (distance < nearestDistance) {
			nearestDistance = distance;
			nearestLocation = location;
		}
	}
	
	if (nearest != NULL) {
		*nearest = nearestLocation;
	}
	
	return nearLocations;
}


@end
