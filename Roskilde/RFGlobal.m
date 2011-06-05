//
//  RFGlobal.m
//  Roskilde
//
//  Created by Willi Wu on 24/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RFGlobal.h"
#import "Reachability.h"


@implementation RFGlobal


+ (NSString *)username
{
	NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsUsername];
	
	if ([username isKindOfClass:[NSString class]])
		 return username;
	
	return nil;
}

+ (NSString *)password
{
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPassword];
	
	if ([password isKindOfClass:[NSString class]])
		return password;
	
	return nil;
}

+ (void)saveUsername:(NSString *)username password:(NSString *)password
{
	NSUserDefaults *userDefauls = [NSUserDefaults standardUserDefaults];
	[userDefauls setObject:username forKey:kUserDefaultsUsername];
	[userDefauls setObject:password forKey:kUserDefaultsPassword];
	[userDefauls synchronize];
}



+ (BOOL)connected
{
	//return NO; // force for offline testing
	Reachability *hostReach = [Reachability reachabilityForInternetConnection];	
	NetworkStatus netStatus = [hostReach currentReachabilityStatus];	
	return !(netStatus == NotReachable);
}


@end
