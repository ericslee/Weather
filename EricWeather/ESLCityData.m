//
//  ESLCityData.m
//  EricWeather
//
//  Created by Eric Lee on 6/17/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLCityData.h"

@implementation ESLCityData

- (id)initWithCity:(NSString *)city andZip:(NSString *)zip
{
    self = [super init];
    
    if (self) {
        self.cityName = city;
        self.zipCode = zip;
    }
    
    return self;
}

@end
