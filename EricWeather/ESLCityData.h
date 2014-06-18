//
//  ESLCityData.h
//  EricWeather
//
//  Created by Eric Lee on 6/17/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//
//  City object - stores basic city information and a ob

#import <Foundation/Foundation.h>
#import "ESLWeatherData.h"

@interface ESLCityData : NSObject

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) ESLWeatherData *weatherData; // stores the weather data for this city

- (id)initWithCity:(NSString *)city andZip:(NSString *)zip;

@end
