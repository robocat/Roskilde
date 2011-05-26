// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RFMusic.h instead.

#import <CoreData/CoreData.h>























@interface RFMusicID : NSManagedObjectID {}
@end

@interface _RFMusic : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RFMusicID*)objectID;



@property (nonatomic, retain) NSString *itunes;

//- (BOOL)validateItunes:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *genre;

//- (BOOL)validateGenre:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *link;

//- (BOOL)validateLink:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *priority;

@property short priorityValue;
- (short)priorityValue;
- (void)setPriorityValue:(short)value_;

//- (BOOL)validatePriority:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *artistInitial;

//- (BOOL)validateArtistInitial:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *duration;

@property short durationValue;
- (short)durationValue;
- (void)setDurationValue:(short)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *beginDate;

//- (BOOL)validateBeginDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *artistId;

//- (BOOL)validateArtistId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *imageUrl;

//- (BOOL)validateImageUrl:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *imageThumbUrl;

//- (BOOL)validateImageThumbUrl:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *web;

//- (BOOL)validateWeb:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *isFavorite;

@property BOOL isFavoriteValue;
- (BOOL)isFavoriteValue;
- (void)setIsFavoriteValue:(BOOL)value_;

//- (BOOL)validateIsFavorite:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *artist;

//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *descriptionText;

//- (BOOL)validateDescriptionText:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *scene;

//- (BOOL)validateScene:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSDate *endDate;

//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *country;

//- (BOOL)validateCountry:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *beginDateString;

//- (BOOL)validateBeginDateString:(id*)value_ error:(NSError**)error_;





@end

@interface _RFMusic (CoreDataGeneratedAccessors)

@end

@interface _RFMusic (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveItunes;
- (void)setPrimitiveItunes:(NSString*)value;




- (NSString*)primitiveGenre;
- (void)setPrimitiveGenre:(NSString*)value;




- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;




- (NSNumber*)primitivePriority;
- (void)setPrimitivePriority:(NSNumber*)value;

- (short)primitivePriorityValue;
- (void)setPrimitivePriorityValue:(short)value_;




- (NSString*)primitiveArtistInitial;
- (void)setPrimitiveArtistInitial:(NSString*)value;




- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (short)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(short)value_;




- (NSDate*)primitiveBeginDate;
- (void)setPrimitiveBeginDate:(NSDate*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveArtistId;
- (void)setPrimitiveArtistId:(NSString*)value;




- (NSString*)primitiveImageUrl;
- (void)setPrimitiveImageUrl:(NSString*)value;




- (NSString*)primitiveImageThumbUrl;
- (void)setPrimitiveImageThumbUrl:(NSString*)value;




- (NSString*)primitiveWeb;
- (void)setPrimitiveWeb:(NSString*)value;




- (NSNumber*)primitiveIsFavorite;
- (void)setPrimitiveIsFavorite:(NSNumber*)value;

- (BOOL)primitiveIsFavoriteValue;
- (void)setPrimitiveIsFavoriteValue:(BOOL)value_;




- (NSString*)primitiveArtist;
- (void)setPrimitiveArtist:(NSString*)value;




- (NSString*)primitiveDescriptionText;
- (void)setPrimitiveDescriptionText:(NSString*)value;




- (NSString*)primitiveScene;
- (void)setPrimitiveScene:(NSString*)value;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSString*)primitiveCountry;
- (void)setPrimitiveCountry:(NSString*)value;




- (NSString*)primitiveBeginDateString;
- (void)setPrimitiveBeginDateString:(NSString*)value;




@end
