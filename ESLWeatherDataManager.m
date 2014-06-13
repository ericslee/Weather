//
//  ESLWeatherDataManager.m
//  EricWeather
//
//  Created by Eric Lee on 6/6/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLWeatherDataManager.h"

@implementation ESLWeatherDataManager

// designated initializer, runs code when object is initialized

- (id)initDefault
{
    self = [super init];
    
    // init dictionary
    _weatherDataDictionary = [[NSMutableDictionary alloc] init];
    
    // init mutable arrays
    self.citiesArray = [[NSMutableArray alloc] init];
    self.zipCodesArray = [[NSMutableArray alloc] init];
    
    // init other data dictionaries
    self.conditionsDictionary = [[NSMutableDictionary alloc] init];
    self.temperatureStringDictionary = [[NSMutableDictionary alloc] init];
    self.iconDictionary = [[NSMutableDictionary alloc] init];
    self.windStringDictionary = [[NSMutableDictionary alloc] init];
    self.humidityStringDictionary = [[NSMutableDictionary alloc] init];
    self.feelsLikeStringDictionary = [[NSMutableDictionary alloc] init];
    self.weatherEffectsDictionary = [[NSMutableDictionary alloc] init];
    
    // perform a HTTP web request and then set our properties
    // default example - San Francisco
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:@"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/94107.json"]];
    NSURLConnection *theConnection=[[NSURLConnection alloc]
                                    initWithRequest:theRequest delegate:self];
    if(theConnection){
        _currentCityWeatherData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"failed");
    }
    
    return self;
}

- (id)initRefreshData:(NSMutableArray *)citiesToReload
{
    NSLog(@"Temp cities count: %@", citiesToReload);
    
    self = [super init];
    
    // init dictionary
    _weatherDataDictionary = [[NSMutableDictionary alloc] init];
    
    // reset mutable array
    self.citiesArray = [[NSMutableArray alloc] init];
    self.zipCodesArray = [[NSMutableArray alloc] init];
    
    // reset other data dictionaries
    self.conditionsDictionary = [[NSMutableDictionary alloc] init];
    self.temperatureStringDictionary = [[NSMutableDictionary alloc] init];
    self.iconDictionary = [[NSMutableDictionary alloc] init];
    self.windStringDictionary = [[NSMutableDictionary alloc] init];
    self.humidityStringDictionary = [[NSMutableDictionary alloc] init];
    self.feelsLikeStringDictionary = [[NSMutableDictionary alloc] init];
    self.weatherEffectsDictionary = [[NSMutableDictionary alloc] init];
    
    // add all cities again with updated data
    for(NSString *city in citiesToReload)
    {
        NSString *newCity = city;
        NSString *httpRequestURL = @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/";
        httpRequestURL = [httpRequestURL stringByAppendingString:newCity];
        NSString *jsonTag = @".json";
        httpRequestURL = [httpRequestURL stringByAppendingString:jsonTag];
        
        [self addCityToModel:httpRequestURL];
    }
    
    return self;
}

- (void)addCityToModel:(NSString *)cityURL
{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:cityURL]];
    NSURLConnection *theConnection=[[NSURLConnection alloc]
                                    initWithRequest:theRequest delegate:self];
    if(theConnection){
        _currentCityWeatherData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"failed");
    }
}

- (void)removeCityFromModel:(NSString *)cityToRemove
{
    // get index of city
    NSInteger cityIndex = [self.citiesArray indexOfObject:cityToRemove];
    // remove city from array
    [self.citiesArray removeObject:cityToRemove];
    // remove zip code
    [self.zipCodesArray removeObjectAtIndex:cityIndex];
    
    NSLog(@"size of cities array: %ld", [self.citiesArray count]);
    
    // remove city from all dictionaries
    [self.weatherDataDictionary removeObjectForKey:cityToRemove];
    [self.conditionsDictionary removeObjectForKey:cityToRemove];
    [self.temperatureStringDictionary removeObjectForKey:cityToRemove];
    [self.iconDictionary removeObjectForKey:cityToRemove];
    [self.windStringDictionary removeObjectForKey:cityToRemove];
    [self.humidityStringDictionary removeObjectForKey:cityToRemove];
    [self.feelsLikeStringDictionary removeObjectForKey:cityToRemove];
    [self.weatherEffectsDictionary removeObjectForKey:cityToRemove];
    
    // update number of keys
    self.numCities = [self.weatherDataDictionary count];
    
    // notify controller that a city has been removed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataReceived"
                                                        object:self];
}

#pragma mark - Delegates for Weather Data

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_currentCityWeatherData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_currentCityWeatherData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *msg = [NSString stringWithFormat:@"Failed: %@", [error description]];
    NSLog(@"%@",msg);
}

// Called on data finish loading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *myError = nil;
    
    
   
        // parse json data
        NSDictionary *rawParsedJson = [NSJSONSerialization JSONObjectWithData:_currentCityWeatherData options:NSJSONReadingMutableLeaves  error:&myError];
        NSArray *results =  [rawParsedJson objectForKey:@"current_observation"];
        if([results count] == 0)
        {
            // handle nil case
            NSLog(@"No suitable city found");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"Not a valid city, state OR zip"
                                                           delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil, nil];
            [alert show];

            
        }
    else
    {
        NSString *city = [[results valueForKey:@"display_location"] valueForKey:@"city"];
        
        // add data to dictionary
        [_weatherDataDictionary setObject:rawParsedJson forKey:city];
        // update number of keys
        _numCities = [_weatherDataDictionary count];
        
        NSArray *parsedJson =  [[_weatherDataDictionary objectForKey:city] objectForKey:@"current_observation"];
        city = [[parsedJson valueForKey:@"display_location"] valueForKey:@"city"];
        
        // Store the city
        [self.citiesArray addObject:city];
                
        // Store the zip
        [self.zipCodesArray addObject:[[parsedJson valueForKey:@"display_location"] valueForKey:@"zip"]];
        
        // Store the weather condition
        [self.conditionsDictionary setObject:[parsedJson valueForKey:@"weather"] forKey:city];
        
        // Store the temperature
        [self.temperatureStringDictionary setObject:[parsedJson valueForKey:@"temp_f"] forKey:city];

        // Store the icon url
        NSString *iconURL = @"http://icons.wxug.com/i/c/i/";
        NSString *iconType = [parsedJson valueForKey:@"icon"];
        iconURL = [iconURL stringByAppendingString:iconType];
        NSString *gifTag = @".gif";
        iconURL = [iconURL stringByAppendingString:gifTag];
        [self.iconDictionary setObject:iconURL forKey:city];
        
        // Store the wind condition
        [self.windStringDictionary setObject:[parsedJson valueForKey:@"wind_string"] forKey:city];
        
        // Store the humidity
        [self.humidityStringDictionary setObject:[parsedJson valueForKey:@"relative_humidity"] forKey:city];
        
        // Store the "feels like"
        [self.feelsLikeStringDictionary setObject:[parsedJson valueForKey:@"feelslike_f"] forKey:city];
        
        // Store the weather effect
        [self.weatherEffectsDictionary setObject:[parsedJson valueForKey:@"icon"] forKey:city];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataReceived"
                                                             object:self];
    }
}


@end
