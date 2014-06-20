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
- (void)updateModelWithCity:(NSArray *)parsedJson
{
    // Get the core data context
    ESLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // check if this city already exists in the city array, update the weather
    NSString *cityName = [[parsedJson valueForKey:DISPLAY_LOCATION_KEY] valueForKey:CITY_KEY];
    for (City *currentCity in self.citiesArray) {
        if ([currentCity.cityName isEqualToString:cityName]) {
            // update the city
            
            // create the fetch request
            NSEntityDescription *entityDesc = [NSEntityDescription
                                               entityForName:@"City" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName == %@", cityName];
            [request setPredicate:predicate];
            [request setEntity:entityDesc];
            NSError *error;
            NSArray *fetchedCities = [context executeFetchRequest:request error:&error];
            
            City *cityObject = [fetchedCities firstObject];
            [self updateCity:cityObject andWeather:cityObject.weatherData withDetails:parsedJson inContext:context];
            //[self updateExistingCity:parsedJson withName:cityName];
            return;
        }
    }
    
    // else, create the new city and add to the model
    City *cityObject = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
    [cityObject setValue:cityName forKey:@"cityName"];
    [cityObject setValue:[[parsedJson valueForKey:DISPLAY_LOCATION_KEY] valueForKey:ZIP_KEY] forKey:@"zipCode"];
    WeatherData *weatherDetails = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherData" inManagedObjectContext:context];
    [self updateCity:cityObject andWeather:weatherDetails withDetails:parsedJson inContext:context];

    //[self addCityToModel:parsedJson withName:cityName];
}

- (void)addCityToModel:(NSArray *)parsedJson withName:(NSString *)cityName
{
    // Create city entity
    ESLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    City *cityObject = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:context];
    [cityObject setValue:cityName forKey:@"cityName"];
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
}

- (void)updateExistingCity:(NSArray *)parsedJson withName:(NSString *)cityName
{
    // Create city entity
    ESLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // create the fetch request
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"City" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName == %@", cityName];
    [request setPredicate:predicate];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *fetchedCities = [context executeFetchRequest:request error:&error];
    
    City *cityObject = [fetchedCities firstObject];
    
    [cityObject setValue:cityName forKey:@"cityName"];
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

}

- (void)updateCity:(City *)cityObject andWeather:(WeatherData *)weatherDetails withDetails:(NSArray *)parsedJson inContext:(NSManagedObjectContext *)context
{
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
}

- (void)removeCityFromModel:(NSInteger)index
{
    // remove city from core data
    ESLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:[self.citiesArray objectAtIndex:index]];
    
    // save to disk
    [self saveToDisk:context];
}

- (void)saveToDisk:(NSManagedObjectContext *)context
{
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}


@end
