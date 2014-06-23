//
//  City.h
//  EricWeather
//
//  Created by Eric Lee on 6/23/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WeatherData;

@interface City : NSManagedObject

@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) WeatherData *weatherData;

@end
