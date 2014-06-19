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

// creates a city entity, saves to core data, and adds to city array
- (void)addCityToModel:(NSArray *)parsedJson
{
    /*
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
    
    */
    
    // Create city entity
    ESLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    City *cityObject = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
    [cityObject setValue:[[parsedJson valueForKey:DISPLAY_LOCATION_KEY] valueForKey:CITY_KEY] forKey:@"cityName"];
    [cityObject setValue:[[parsedJson valueForKey:DISPLAY_LOCATION_KEY] valueForKey:ZIP_KEY] forKey:@"zipCode"];
    
    // create weather object
    WeatherData *weatherDetails = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherData" inManagedObjectContext:context];
    [weatherDetails setValue:[parsedJson valueForKey:WEATHER_KEY] forKey:@"condition"];
    [weatherDetails setValue:[parsedJson valueForKey:TEMP_KEY] forKey:@"temperatureF"];
    NSString *iconURL = ICON_URL;
    NSString *iconType = [parsedJson valueForKey:ICON_KEY];
    iconURL = [iconURL stringByAppendingString:iconType];
    iconURL = [iconURL stringByAppendingString:GIF_EXTENSION];
    [weatherDetails setValue:iconURL forKey:@"icon"];
    [weatherDetails setValue:[parsedJson valueForKey:WIND_KEY] forKey:@"wind"];
    [weatherDetails setValue:[parsedJson valueForKey:HUMIDITY_KEY] forKey:@"humidity"];
    [weatherDetails setValue:[parsedJson valueForKey:FEELS_LIKE_KEY] forKey:@"feelsLike"];
    [weatherDetails setValue:[parsedJson valueForKey:ICON_KEY] forKey:@"weatherEffect"];
    
     // assign the weather object and city object to each other
    [weatherDetails setValue:cityObject forKey:@"cityData"];
    [cityObject setValue:weatherDetails forKey:@"weatherData"];
    
    // save to disk
    [self saveToDisk:context];
    
    /*
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"City" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"cityName"]);
        NSManagedObject *details = [info valueForKey:@"weatherData"];
        NSLog(@"Condition: %@", [details valueForKey:@"condition"]);
    }
    */
     
    // add city to the array
    [self.citiesArray addObject:cityObject];
    NSLog(@"Cities Array count: %ld", [self.citiesArray count]);
}

- (void)removeCityFromModel:(NSInteger)index
{
    // remove city from core data
    ESLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:[self.citiesArray objectAtIndex:index]];
    
    // save to disk
    [self saveToDisk:context];
    
    // remove city from array
    [self.citiesArray removeObjectAtIndex:index];
}

- (void)saveToDisk:(NSManagedObjectContext *)context
{
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


@end
