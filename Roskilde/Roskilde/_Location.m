// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Location.m instead.

#import "_Location.h"

@implementation LocationID
@end

@implementation _Location

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Location";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Location" inManagedObjectContext:moc_];
}

- (LocationID*)objectID {
	return (LocationID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"latValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"lonValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lon"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic name;






@dynamic type;






@dynamic lat;



- (float)latValue {
	NSNumber *result = [self lat];
	return [result floatValue];
}

- (void)setLatValue:(float)value_ {
	[self setLat:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatValue {
	NSNumber *result = [self primitiveLat];
	return [result floatValue];
}

- (void)setPrimitiveLatValue:(float)value_ {
	[self setPrimitiveLat:[NSNumber numberWithFloat:value_]];
}





@dynamic area;






@dynamic lon;



- (float)lonValue {
	NSNumber *result = [self lon];
	return [result floatValue];
}

- (void)setLonValue:(float)value_ {
	[self setLon:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLonValue {
	NSNumber *result = [self primitiveLon];
	return [result floatValue];
}

- (void)setPrimitiveLonValue:(float)value_ {
	[self setPrimitiveLon:[NSNumber numberWithFloat:value_]];
}





@dynamic map;










@end
