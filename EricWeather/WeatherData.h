//
//  WeatherData.h
//  EricWeather
//
//  Created by Eric Lee on 6/19/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface WeatherData : NSManagedObject

@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) NSString * temperatureF;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * wind;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * feelsLike;
@property (nonatomic, retain) NSString * weatherEffect; // determines weather effect on the detail view
@property (nonatomic, retain) City *cityData;

@end
