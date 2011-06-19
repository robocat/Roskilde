//
//  RFGlobal.h
//  Roskilde
//
//  Created by Willi Wu on 24/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kConcertsFeed		@"http://roskildefeed.mads379.cloudbees.net/feed/xml"
#define kXdkAPIKey			@""
#define kXdkAPIBaseUrl		@"https://xdkapi.appspot.com/api/roskilde"



#define kUserDefaultsUsername		@"kUserDefaultsUsername"
#define kUserDefaultsPassword		@"kUserDefaultsPassword"

#define kPromptCreateProfile		@"kPromptCreateProfile"
#define kUserLoggedIn				@"kUserLoggedIn"

#define kMusicDataImported			@"kMusicDataImported"

#define kAppEnterBackground			@"kAppEnterBackground"


@interface RFGlobal : NSObject {
    
}

+ (NSString *)username;
+ (NSString *)password;
+ (void)saveUsername:(NSString *)username password:(NSString *)password;
+ (BOOL)connected;

@end
