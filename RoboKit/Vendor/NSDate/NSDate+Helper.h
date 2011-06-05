//
//  NSDate+Helper.h
//  Outside
//
//  Created by Willi Wu on 07/08/09.
//  Copyright 2009 icelantern. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (HelperMore)
+ (NSDate *)dateWithoutTime;
+ (NSString *)dbFormatString;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)localDateFromUTCFormattedDate:(NSDate *)sourceDate;
+ (NSDate *)localDateFromUTCFormattedDateString:(NSString *)dateString;
+ (NSString *)strFromISO8601:(NSDate *)date;



- (NSString *)getUTCFormattedDate:(BOOL)timeOnly;
- (NSDate *)dateByAddingDays:(NSInteger)numDays;
- (NSDate *)dateByAddingHours:(NSInteger)numHours;
- (NSDate *)dateAsDateWithoutTime;
- (int)differenceInDaysTo:(NSDate *)toDate;
- (NSString *)formattedDateString;
- (NSString *)formattedDateStringForDisplay;
- (NSString *)formattedTimeStringForDisplay;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;

- (NSDate *) localDateFromTimeDifference:(NSInteger)diff;

- (int)hourFromDate;
- (int)minuteFromDate;
- (NSUInteger)weekday;
- (NSString *)weekdayString;
- (NSString *)weekdayShortString;


- (NSString *)relativeDate;
- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString;
- (NSString*)formattedExactRelativeDate;
- (NSString *) formattedExactRelativeMinutes;

@end
