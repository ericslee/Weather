//
//  ESLWeatherDataManager.h
//  EricWeather
//
//  Created by Eric Lee on 6/6/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESLCityData.h"

#define SFO_URL @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/94107.json"
#define HTTP_REQUEST_URL @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/"
#define JSON_EXTENSION @".json"
#define ICON_URL @"http://icons.wxug.com/i/c/i/"
#define GIF_EXTENSION @".gif"

@interface ESLWeatherDataManager : NSObject

// weather data for most recent city
@property (nonatomic, strong) NSMutableData *currentCityWeatherData;

// number of cities in list (and therefore number of keys)
@property (nonatomic) NSInteger numCities;
// stores weather json parsed as dictionaries in a dictionary w/ city as the key
@property (nonatomic, strong) NSMutableDictionary *weatherDataDictionary;

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

// current cell index
@property (nonatomic) NSInteger currentIndex;



// default initializer that loads S.F. data
- (id)initDefault;

// refreshes data for all cities added
- (id)initRefreshData:(NSMutableArray *)citiesToReload;

// add city to model
- (void)addCityToModel:(NSString *)cityURL;

// remove swiped city from model
- (void)removeCityFromModel:(NSString *)cityToRemove;


@end
