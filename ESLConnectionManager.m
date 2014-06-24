//
//  ESLConnectionManager.m
//  EricWeather
//
//  Created by Eric Lee on 6/24/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLConnectionManager.h"

@implementation ESLConnectionManager

+ (ESLConnectionManager*)sharedInstance
{
    // declare a static variable for instance of this class, ensuring global availibilty
    static ESLConnectionManager *_sharedInstance = nil;
    
    // ensures initialization code executes only once
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ESLConnectionManager alloc] init];
    });
    return _sharedInstance;
}

@end
