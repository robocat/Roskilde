//
//  DDKCustomTabButton.h
//  VAOMoscowGuide
//
//  Created by Dmitry Sukhorukov on 10/13/10.
//  Copyright 2010 AR Door. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface DDKCustomTabButton : UIButton {
@private
	CAGradientLayer* gradientLayer; 
	CALayer* iconLayer;
	CALayer* iconSelectedLayer;
	NSUInteger shadowSize;
}

@property (nonatomic, retain) CAGradientLayer* gradientLayer;
@property (nonatomic) NSUInteger shadowSize;
@property (nonatomic, retain) CALayer* iconLayer;
@property (nonatomic, retain) CALayer* iconSelectedLayer;

+(id) buttonWithImage:(UIImage*)normalImage selected:(UIImage*)selImage upShadowSize:(CGFloat)shadowSize icon:(UIImage*)icon iconSelected:(UIImage*)iconSelected;

@end
