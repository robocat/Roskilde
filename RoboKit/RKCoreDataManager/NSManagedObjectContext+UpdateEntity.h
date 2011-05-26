//
//  NSManagedObjectContext+UpdateEntity.h
//  Podio
//
//  Created by Willi Wu on 07/10/10.
//  Copyright 2010 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (UpdateEntity)
- (void)updateEntity:(NSString *)entity fromDictionary:(NSDictionary *)importDict withIdentifier:(NSString *)identifier overwriting:(NSArray *)overwritables andError:(NSError **)error;
@end