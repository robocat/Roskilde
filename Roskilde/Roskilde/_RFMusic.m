// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RFMusic.m instead.

#import "_RFMusic.h"

@implementation RFMusicID
@end

@implementation _RFMusic

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Music" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Music";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Music" inManagedObjectContext:moc_];
}

- (RFMusicID*)objectID {
	return (RFMusicID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"priorityValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"priority"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"durationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"duration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"isFavoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFavorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic itunes;






@dynamic genre;






@dynamic link;






@dynamic priority;



- (short)priorityValue {
	NSNumber *result = [self priority];
	return [result shortValue];
}

- (void)setPriorityValue:(short)value_ {
	[self setPriority:[NSNumber numberWithShort:value_]];
}

- (short)primitivePriorityValue {
	NSNumber *result = [self primitivePriority];
	return [result shortValue];
}

- (void)setPrimitivePriorityValue:(short)value_ {
	[self setPrimitivePriority:[NSNumber numberWithShort:value_]];
}





@dynamic artistInitial;






@dynamic duration;



- (short)durationValue {
	NSNumber *result = [self duration];
	return [result shortValue];
}

- (void)setDurationValue:(short)value_ {
	[self setDuration:[NSNumber numberWithShort:value_]];
}

- (short)primitiveDurationValue {
	NSNumber *result = [self primitiveDuration];
	return [result shortValue];
}

- (void)setPrimitiveDurationValue:(short)value_ {
	[self setPrimitiveDuration:[NSNumber numberWithShort:value_]];
}





@dynamic beginDate;






@dynamic title;






@dynamic artistId;






@dynamic imageUrl;






@dynamic imageThumbUrl;






@dynamic web;






@dynamic isFavorite;



- (BOOL)isFavoriteValue {
	NSNumber *result = [self isFavorite];
	return [result boolValue];
}

- (void)setIsFavoriteValue:(BOOL)value_ {
	[self setIsFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFavoriteValue {
	NSNumber *result = [self primitiveIsFavorite];
	return [result boolValue];
}

- (void)setPrimitiveIsFavoriteValue:(BOOL)value_ {
	[self setPrimitiveIsFavorite:[NSNumber numberWithBool:value_]];
}





@dynamic artist;






@dynamic descriptionText;






@dynamic scene;






@dynamic endDate;






@dynamic country;






@dynamic beginDateString;










@end
