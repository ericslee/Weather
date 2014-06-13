//
//  ESLBackgroundLayer.m
//  EricWeather
//
//  Created by Eric Lee on 6/10/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLBackgroundLayer.h"

@implementation ESLBackgroundLayer

//Blue gradient background
+ (CAGradientLayer*) rainGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Sunny gradient background
+ (CAGradientLayer*) sunnyGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(252/255.0)  green:(244/255.0)  blue:(192/255.0)  alpha:1.0]; // lighter color
    UIColor *colorTwo = [UIColor colorWithRed:(255/255.0) green:(227/255.0) blue:(43/255.0) alpha:1.0]; // darker color
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Snowy gradient background
+ (CAGradientLayer*) snowGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(247/255.0)  green:(247/255.0)  blue:(247/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(222/255.0) green:(222/255.0) blue:(222/255.0) alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Cloudy gradient background
+ (CAGradientLayer*) cloudyGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(176/255.0)  green:(219/255.0)  blue:(255/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(152/255.0) green:(166/255.0) blue:(179/255.0) alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end