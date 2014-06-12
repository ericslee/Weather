//
//  ESLWeatherDataManager.h
//  EricWeather
//
//  Created by Eric Lee on 6/6/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ESLViewController.h"

@interface ESLWeatherDataManager : NSObject

- (id)initDefault; // default initializer that loads S.F. data
- (id)initRefreshData:(NSMutableArray *)citiesToReload; // refreshes data for all cities added
- (void)addCityToModel:(NSString *)cityURL; // add city to model
- (void)removeCityFromModel:(NSString *)cityToRemove; // remove swiped city from model

@property (nonatomic, strong) NSMutableData *currentCityWeatherData; // weather data for most recent city

@property (nonatomic) NSInteger numCities; // number of cities in list (and therefore number of keys)
@property (nonatomic, strong) NSMutableDictionary *weatherDataDictionary; // stores weather json parsed as dictionaries in a dictionary w/ city as the key

// stores all cities in list to maintain ordering
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *zipCodesArray;

// store all other properties in dictionary
@property (nonatomic, strong) NSMutableDictionary *conditionsDictionary; // weather conditions
@property (nonatomic, strong) NSMutableDictionary *temperatureStringDictionary; // temperature in F and C
@property (nonatomic, strong) NSMutableDictionary *iconDictionary; // weather icon
@property (nonatomic, strong) NSMutableDictionary *windStringDictionary; 
@property (nonatomic, strong) NSMutableDictionary *humidityStringDictionary;
@property (nonatomic, strong) NSMutableDictionary *feelsLikeStringDictionary;
@property (nonatomic, strong) NSMutableDictionary *weatherEffectsDictionary; // determines weather effect on the detail view

@property (nonatomic) NSInteger currentIndex; // current cell index

@end
