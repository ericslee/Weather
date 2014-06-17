//
//  ESLWeatherData.h
//  EricWeather
//
//  Created by Eric Lee on 6/17/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESLWeatherData : NSObject

@property (nonatomic, strong) NSString *condition; // weather conditions
@property (nonatomic, strong) NSString *temperature; // temperature in F and C
@property (nonatomic, strong) NSString *iconDictionary; // weather icon
@property (nonatomic, strong) NSString *windStringDictionary;
@property (nonatomic, strong) NSString *humidityStringDictionary;
@property (nonatomic, strong) NSString *feelsLikeStringDictionary;
@property (nonatomic, strong) NSString *weatherEffectsDictionary; // determines weather effect on the detail view

@end
