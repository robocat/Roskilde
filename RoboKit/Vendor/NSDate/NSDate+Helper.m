//
//  NSDate+Helper.m
//  Outside
//
//  Created by Willi Wu on 07/08/09.
//  Copyright 2009 icelantern. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (HelperMore)
+ (NSDate *)dateWithoutTime {
    return [[NSDate date] dateAsDateWithoutTime];
}

+ (NSString *)dbFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

+ (NSDate *)dateFromString:(NSString *)string {
	NSLocale *POSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setLocale:POSIXLocale];  
	[inputFormatter setDateFormat:[NSDate dbFormatString]];
	NSDate *date = [inputFormatter dateFromString:string];
	[inputFormatter release];
	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	NSLocale *POSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setLocale:POSIXLocale];  
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:date];
	[outputFormatter release];
	return timestamp_str;
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [NSDate stringFromDate:date withFormat:[NSDate dbFormatString]];
}


+ (NSDate *)localDateFromUTCFormattedDate:(NSDate *)sourceDate {
	NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
	
	NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
	NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
	NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
	
	return [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
}


+ (NSDate *)localDateFromUTCFormattedDateString:(NSString *)dateString {
	NSLocale *POSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:POSIXLocale];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate* sourceDate = [formatter dateFromString:dateString];
	[formatter release];
		
	return [self localDateFromUTCFormattedDate:sourceDate];
}

+ (NSString *)strFromISO8601:(NSDate *)date {
    static NSDateFormatter* sISO8601 = nil;
	
    if (!sISO8601) {
#define ISO_TIMEZONE_UTC_FORMAT @"Z"
#define ISO_TIMEZONE_OFFSET_FORMAT @"%+02d%02d"
		
        sISO8601 = [[NSDateFormatter alloc] init];
		
		NSLocale *POSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
		[sISO8601 setLocale:POSIXLocale];
		
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        int offset = [timeZone secondsFromGMT];
		
        NSMutableString *strFormat = [[NSMutableString alloc] initWithString:@"yyyy-MM-dd'T'HH:mm:ss"];
        offset /= 60; //bring down to minutes
        if (offset == 0)
            [strFormat appendString:ISO_TIMEZONE_UTC_FORMAT];
        else
            [strFormat appendFormat:ISO_TIMEZONE_OFFSET_FORMAT, offset / 60, offset % 60];
		
        [sISO8601 setTimeStyle:NSDateFormatterFullStyle];
        [sISO8601 setDateFormat:strFormat];
		[strFormat release];
    }
	
    return [sISO8601 stringFromDate:date];
}



- (NSString *)getUTCFormattedDate:(BOOL)timeOnly {
	NSLocale *POSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:POSIXLocale];
	NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	[formatter setTimeZone:timeZone];
	if (timeOnly) {
		[formatter setDateFormat:@"HH:mm:ss"];
	}
	else {
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	}
	NSString *dateString = [formatter stringFromDate:self];
	[formatter release];
	return dateString;
}


- (NSDate *)dateByAddingDays:(NSInteger)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:numDays];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    [comps release];
    [gregorian release];
    return date;
}

- (NSDate *)dateByAddingHours:(NSInteger)numHours {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:numHours];
    
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:self options:0];
    [comps release];
    [gregorian release];
    return date;
}

- (NSDate *)dateAsDateWithoutTime {
    NSString *formattedString = [self formattedDateString];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *ret = [formatter dateFromString:formattedString];
    [formatter release];
    return ret;
}

- (int)differenceInDaysTo:(NSDate *)toDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit
                                                fromDate:self
                                                  toDate:toDate
                                                 options:0];
    NSInteger days = [components day];
    [gregorian release];
    return days;
}

- (NSString *)formattedDateString {
    return [self formattedStringUsingFormat:@"yyyy-MM-dd"];
}

- (NSString *)formattedDateStringForDisplay {
    return [self formattedStringUsingFormat:@"EEEE MMM d"]; //MMM d, YYYY
}

- (NSString *)formattedTimeStringForDisplay {
    return [self formattedStringUsingFormat:@"HH:mm"];
}

- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:self];
    [formatter release];
    return ret;
}


- (NSDate *) localDateFromTimeDifference:(NSInteger)diff {
	NSTimeZone* sourceTimeZone			= [NSTimeZone timeZoneForSecondsFromGMT:diff * 60 * 60];
	NSTimeZone* destinationTimeZone		= [NSTimeZone systemTimeZone];
	
	NSInteger sourceGMTOffset			= [sourceTimeZone secondsFromGMTForDate:self];
	NSInteger destinationGMTOffset		= [destinationTimeZone secondsFromGMTForDate:self];
	
	NSTimeInterval interval				= destinationGMTOffset - sourceGMTOffset;
	
	NSDate* destinationDate				= [[[NSDate alloc] initWithTimeInterval:interval sinceDate:self] autorelease];
	
	return destinationDate;
}



- (int)hourFromDate {
	NSLocale *POSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:POSIXLocale];
	[formatter setDateFormat:@"HH"];
	NSString* ret = [formatter stringFromDate:self];
	[formatter release];
	int hour = [ret intValue];
	
//	if ([self minuteFromDate] == 0) {
//		hour++;
//	}
	return hour;
}

- (int)minuteFromDate {
	NSLocale *POSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:POSIXLocale];
	[formatter setDateFormat:@"mm"];
	NSString* ret = [formatter stringFromDate:self];
	[formatter release];
	return [ret intValue];
}

- (NSUInteger)weekday {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

- (NSString *)weekdayString {
	NSString *weekday = @"";
	switch ([self weekday]) {
		case 1:
			weekday = NSLocalizedString(@"Sunday", @"Week day");
			break;
		case 2:
			weekday = NSLocalizedString(@"Monday", @"Week day");
			break;
		case 3:
			weekday = NSLocalizedString(@"Tuesday", @"Week day");
			break;
		case 4:
			weekday = NSLocalizedString(@"Wednesday", @"Week day");
			break;
		case 5:
			weekday = NSLocalizedString(@"Thursday", @"Week day");
			break;
		case 6:
			weekday = NSLocalizedString(@"Friday", @"Week day");
			break;
		case 7:
			weekday = NSLocalizedString(@"Saturday", @"Week day");
			break;
		default:
			weekday = @"";
			break;
	}
	
	return weekday;
}

- (NSString *)weekdayShortString {
	NSString *weekday = @"";
	switch ([self weekday]) {
		case 1:
			weekday = NSLocalizedString(@"Sun", @"Week day abbreviation");
			break;
		case 2:
			weekday = NSLocalizedString(@"Mon", @"Week day abbreviation");
			break;
		case 3:
			weekday = NSLocalizedString(@"Tue", @"Week day abbreviation");
			break;
		case 4:
			weekday = NSLocalizedString(@"Wed", @"Week day abbreviation");
			break;
		case 5:
			weekday = NSLocalizedString(@"Thu", @"Week day abbreviation");
			break;
		case 6:
			weekday = NSLocalizedString(@"Fri", @"Week day abbreviation");
			break;
		case 7:
			weekday = NSLocalizedString(@"Sat", @"Week day abbreviation");
			break;
		default:
			weekday = @"";
			break;
	}
	
	return weekday;
}


- (NSString *)relativeDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit;
	
	NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date] toDate:self options:0];
	
	NSInteger relativeNumber;	
	NSArray *selectorNames = [NSArray arrayWithObjects:@"year", @"month", @"week", @"day", nil]; // Will check by order
	
	for (NSString *selectorName in selectorNames) {
		relativeNumber = (NSInteger)[components performSelector:NSSelectorFromString(selectorName)];
		if (relativeNumber) {
			NSString *ago;
			
			if (relativeNumber == -1) {
				ago = NSLocalizedString(@" ago", @"Day ago. Singular");
			}
			else if (relativeNumber < -1) {
				ago = NSLocalizedString(@"s ago", @"Days ago. Plural");
			}
			else if (relativeNumber > 1) {
				ago = NSLocalizedString(@"s", @"Days. Plural");
			}
			else {
				ago = @"";
			}
			
			NSString *dateString = [[NSString alloc] initWithFormat:@"%d %@%@", abs(relativeNumber), selectorName, ago]; //[selectorName substringToIndex:1]
			
			return [dateString autorelease];
		}
	}
	
	return NSLocalizedString(@"Today", @"Today");
}


- (NSString*)formattedDateWithFormatString:(NSString*)dateFormatterString {
	if(!dateFormatterString) return nil;
	
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setDateFormat:dateFormatterString];
	[formatter setAMSymbol:@"am"];
	[formatter setPMSymbol:@"pm"];
	return [formatter stringFromDate:self];
}

- (NSString *) formattedExactRelativeDate {
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSTimeInterval diff = now - time;
	
	if(diff < 10) {
		return LocalizedString(@"just now");
	} else if(diff < 60) {
		return LocalizedStringWithFormat(@"%d seconds ago", (int)diff);
	}
	
	diff = round(diff/60);
	if(diff < 60) {
		if(diff == 1) {
			return LocalizedStringWithFormat(@"%d minute ago", (int)diff);
		} else {
			return LocalizedStringWithFormat(@"%d minutes ago", (int)diff);
		}
	}
	
	diff = round(diff/60);
	if(diff < 24) {
		if(diff == 1) {
			return LocalizedStringWithFormat(@"%d hour ago", (int)diff);
		} else {
			return LocalizedStringWithFormat(@"%d hours ago", (int)diff);
		}
	}
	
	diff = round(diff/24);
	if(diff < 7) {
		if(diff == 1) {
			return LocalizedString(@"yesterday");
		} else {
			return LocalizedStringWithFormat(@"%d days ago", (int)diff);
		}
	}
	
	return [self formattedDateWithFormatString:LocalizedString(@"MM/dd/yy")];
}

- (NSString *) formattedExactRelativeMinutes {
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSTimeInterval diff = now - time;
	
	if(diff < 60) {
		return LocalizedStringWithFormat(@"%ds", (int)diff);
	}
	
	diff = round(diff/60);
	if(diff < 60) {
		return LocalizedStringWithFormat(@"%dm", (int)diff);
	}
	
	diff = round(diff/60);
	if(diff < 48) {
		return LocalizedStringWithFormat(@"%dh", (int)diff);
	}
	
	diff = round(diff/24);
	return LocalizedStringWithFormat(@"%dd", (int)diff);
}

@end
