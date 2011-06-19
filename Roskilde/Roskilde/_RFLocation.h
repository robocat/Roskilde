// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RFLocation.h instead.

#import <CoreData/CoreData.h>










@interface RFLocationID : NSManagedObjectID {}
@end

@interface _RFLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RFLocationID*)objectID;



@property (nonatomic, retain) NSString *name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *map;

//- (BOOL)validateMap:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *area;

//- (BOOL)validateArea:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *lon;

@property float lonValue;
- (float)lonValue;
- (void)setLonValue:(float)value_;

//- (BOOL)validateLon:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *lat;

@property float latValue;
- (float)latValue;
- (void)setLatValue:(float)value_;

//- (BOOL)validateLat:(id*)value_ error:(NSError**)error_;





@end

@interface _RFLocation (CoreDataGeneratedAccessors)

@end

@interface _RFLocation (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;




- (NSString*)primitiveMap;
- (void)setPrimitiveMap:(NSString*)value;




- (NSString*)primitiveArea;
- (void)setPrimitiveArea:(NSString*)value;




- (NSNumber*)primitiveLon;
- (void)setPrimitiveLon:(NSNumber*)value;

- (float)primitiveLonValue;
- (void)setPrimitiveLonValue:(float)value_;




- (NSNumber*)primitiveLat;
- (void)setPrimitiveLat:(NSNumber*)value;

- (float)primitiveLatValue;
- (void)setPrimitiveLatValue:(float)value_;




@end
