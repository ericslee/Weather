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
@property (nonatomic, strong) NSString *icon; // weather icon
@property (nonatomic, strong) NSString *wind;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *feelsLike;
@property (nonatomic, strong) NSString *weatherEffect; // determines weather effect on the detail view

@end
