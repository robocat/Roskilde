//
//  LocationManager.h
//  Roskilde
//
//  Created by Ulrik Damm on 5/27/11.
//  Copyright 2011 Gereen.dk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

+ (void)loadLocationData;
+ (NSArray*)locationObjectsForPosition:(CLLocationCoordinate2D)coordinate nearest:(RFLocation**)nearest;

@end
