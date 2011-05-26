/*
 *  RKMacro.h
 *  Podio
 *
 *  Created by Willi Wu on 02/09/10.
 *  Copyright 2010 Robocat. All rights reserved.
 *
 */

#import "VTPG_Common.h"

// Short hand NSLocalizedString, doesn't need 2 parameters
#define LocalizedString(s) NSLocalizedString(s,s)

// LocalizedString with an additionl parameter for formatting
#define LocalizedStringWithFormat(s,...) [NSString stringWithFormat:NSLocalizedString(s,s),##__VA_ARGS__]

// Alert
//Alert(AlertInvalidJSON, @"Title", @"Message", @"Button", nil);
#define Alert(tag, title, msg, button, buttons...) {UIAlertView *__alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:button otherButtonTitles:buttons];[__alert setTag:tag]; [__alert show];[__alert release];}

// Safe Release
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }



// Color helpers

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 \
alpha:(a)]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

#define RGBA(r,g,b,a) (r)/255.0, (g)/255.0, (b)/255.0, (a)

#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
