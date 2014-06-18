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
#define CURRENT_OBSERVATION_KEY @"current_observation"
#define DISPLAY_LOCATION_KEY @"display_location"
#define CITY_KEY @"city"
#define ZIP_KEY @"zip"
#define WEATHER_KEY @"weather"
#define TEMP_KEY @"temp_f"
#define ICON_KEY @"icon"
#define WIND_KEY @"wind_string"
#define HUMIDITY_KEY @"relative_humidity"
#define FEELS_LIKE_KEY @"feelslike_f"

@interface ESLWeatherDataManager : NSObject

// weather data for most recent city
@property (nonatomic, strong) NSMutableData *currentCityWeatherData;

// stores all cities in list to maintain ordering
@property (nonatomic, strong) NSMutableArray *citiesArray;

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
