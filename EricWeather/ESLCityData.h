//
//  ESLCityData.h
//  EricWeather
//
//  Created by Eric Lee on 6/17/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESLWeatherData.h"

@interface ESLCityData : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) ESLWeatherData *weatherData;

- (id)initWithCity:(NSString *)city andZip:(NSString *)zip;

@end
