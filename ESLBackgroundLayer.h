//
//  ESLBackgroundLayer.h
//  EricWeather
//
//  Created by Eric Lee on 6/10/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//
//  Used for creating gradient backgrounds
//TODO: based on current time

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ESLBackgroundLayer : NSObject

+(CAGradientLayer*) greyGradient;
+(CAGradientLayer*) blueGradient;
+(CAGradientLayer*) sunnyGradient;
+(CAGradientLayer*) snowGradient;
+(CAGradientLayer*) cloudyGradient;

@end