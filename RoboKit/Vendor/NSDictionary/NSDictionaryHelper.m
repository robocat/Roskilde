//
//  NSDictionaryHelper.m
//  Roskilde
//
//  Created by Willi Wu on 28/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionaryHelper.h"


@implementation NSDictionary (NSDictionaryHelper)

- (id)objectOrEmptyStringForKey:(id)aKey
{
	id object = [self objectForKey:aKey];
	
	if ([object isKindOfClass:[NSNull class]])
		return @"";
	
	return object;
}

@end
