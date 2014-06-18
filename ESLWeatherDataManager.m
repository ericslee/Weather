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
        
        // add SF as the default initial city
        [self addCityToModel:SFO_URL];
    }
    return self;
}

// initializer when table is refreshed
- (id)initRefreshData:(NSMutableArray *)citiesToReload
{
    self = [super init];
    
    if (self) {
        // empty cities array
        //[self.citiesArray removeAllObjects];
        self.citiesArray = [[NSMutableArray alloc] init];
        
        // add all cities again with updated data
        for(NSString *city in citiesToReload)
        {
            NSString *newCity = city;
            NSString *httpRequestURL = HTTP_REQUEST_URL;
            httpRequestURL = [httpRequestURL stringByAppendingString:newCity];
            httpRequestURL = [httpRequestURL stringByAppendingString:JSON_EXTENSION];
            
            [self addCityToModel:httpRequestURL];
        }
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
    // remove city from array
    [self.citiesArray removeObject:cityToRemove];
    
    // notify controller that a city has been removed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataReceived"
                                                        object:self];
}

#pragma mark - Connection delegates

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
        // handle invalid input
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
        NSArray *parsedJson =  [rawParsedJson objectForKey:@"current_observation"];
        
        // create the city object
        NSString *cityName = [[results valueForKey:@"display_location"] valueForKey:@"city"];
        NSString *zipName = [[results valueForKey:@"display_location"] valueForKey:@"zip"];
        ESLCityData *city = [[ESLCityData alloc] initWithCity:cityName andZip:zipName];
        
        // create the weather object
        ESLWeatherData *weatherForCity = [[ESLWeatherData alloc] init];
        weatherForCity.condition = [parsedJson valueForKey:@"weather"];
        weatherForCity.temperature = [parsedJson valueForKey:@"temp_f"];
        
        NSString *iconURL = ICON_URL;
        NSString *iconType = [parsedJson valueForKey:@"icon"];
        iconURL = [iconURL stringByAppendingString:iconType];
        iconURL = [iconURL stringByAppendingString:GIF_EXTENSION];
        weatherForCity.icon = iconURL;
        
        weatherForCity.wind = [parsedJson valueForKey:@"wind_string"];
        weatherForCity.humidity = [parsedJson valueForKey:@"relative_humidity"];
        weatherForCity.feelsLike = [parsedJson valueForKey:@"feelslike_f"];
        weatherForCity.weatherEffect = [parsedJson valueForKey:@"icon"];
        
        // assign the weather object to the city
        city.weatherData = weatherForCity;
        
        // add city to the array
        [self.citiesArray addObject:city];
        NSLog(@"Cities Array count: %ld", [self.citiesArray count]);
        
        // Notify the controller that the data has been updated
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DataReceived"
                                                             object:self];
    }
}


@end
