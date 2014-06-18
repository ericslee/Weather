//
//  ESLWeatherDataManager.m
//  EricWeather
//
//  Created by Eric Lee on 6/6/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLWeatherDataManager.h"

@implementation ESLWeatherDataManager

// initializer when app first opens
- (id)initDefault
{
    self = [super init];
    
    if (self) {
        // init mutable arrays
        self.citiesArray = [[NSMutableArray alloc] init];
        }
    return self;
}

- (void)addCityToModel:(NSArray *)parsedJson
{
    // create the city object
    NSString *cityName = [[parsedJson valueForKey:DISPLAY_LOCATION_KEY] valueForKey:CITY_KEY];
    NSString *zipName = [[parsedJson valueForKey:DISPLAY_LOCATION_KEY] valueForKey:ZIP_KEY];
    ESLCityData *city = [[ESLCityData alloc] initWithCity:cityName andZip:zipName];
    
    // create the weather object
    ESLWeatherData *weatherForCity = [[ESLWeatherData alloc] init];
    weatherForCity.condition = [parsedJson valueForKey:WEATHER_KEY];
    weatherForCity.temperature = [parsedJson valueForKey:TEMP_KEY];
    
    NSString *iconURL = ICON_URL;
    NSString *iconType = [parsedJson valueForKey:ICON_KEY];
    iconURL = [iconURL stringByAppendingString:iconType];
    iconURL = [iconURL stringByAppendingString:GIF_EXTENSION];
    weatherForCity.icon = iconURL;
    
    weatherForCity.wind = [parsedJson valueForKey:WIND_KEY];
    weatherForCity.humidity = [parsedJson valueForKey:HUMIDITY_KEY];
    weatherForCity.feelsLike = [parsedJson valueForKey:FEELS_LIKE_KEY];
    weatherForCity.weatherEffect = [parsedJson valueForKey:ICON_KEY];
    
    // assign the weather object to the city
    city.weatherData = weatherForCity;
    
    // add city to the array
    [self.citiesArray addObject:city];
    NSLog(@"Cities Array count: %ld", [self.citiesArray count]);
}

- (void)removeCityFromModel:(NSInteger)index
{
    // remove city from array
    [self.citiesArray removeObjectAtIndex:index];
    //[self.citiesArray removeObject:cityToRemove];
}






@end
