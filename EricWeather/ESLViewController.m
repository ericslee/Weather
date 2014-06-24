//
//  ESLViewController.m
//  EricWeather
//
//  Created by Eric Lee on 6/5/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLViewController.h"

@implementation ESLViewController

// lazy instantiation for main model
- (ESLWeatherDataManager *)mainModel
{
    if (!_mainModel) {
        _mainModel = [[ESLWeatherDataManager alloc] initDefault];
        
        // load from core data
        [self fetchCities];
    }
    
    // set current location based on city
    // self.currentLocation = @"94107";
    
    return _mainModel;
}

// fetch request to get cities from core data
- (void)fetchCities
{
    // get the managed object context
    ESLCoreDataManager *coreDataManager = [ESLCoreDataManager sharedInstance];
    NSManagedObjectContext *context = [coreDataManager managedObjectContext];
    
    // create the fetch request
    NSEntityDescription *entityDesc = [NSEntityDescription
                                       entityForName:@"City" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *fetchedCities = [context executeFetchRequest:request error:&error];
    
    // assign result to model
    self.mainModel.citiesArray = fetchedCities;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // gradient positioning
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.maskLayer.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // set the background
    UIImage *backgroundImage = [UIImage imageNamed:BACKGROUND_IMAGE_URL];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    // remove separator lines
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Add gradient on top and bottom borders
    if (!self.maskLayer)
    {
        self.maskLayer = [CAGradientLayer layer];
        self.maskLayer.frame = self.tableView.bounds;
        CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
        CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
        
        self.maskLayer.colors = [NSArray arrayWithObjects:(__bridge id)outerColor,
                                 (__bridge id)innerColor, (__bridge id)innerColor, (__bridge id)outerColor, nil];
        self.maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                                    [NSNumber numberWithFloat:0.1],
                                    [NSNumber numberWithFloat:0.9],
                                    [NSNumber numberWithFloat:1.0], nil];
        self.maskLayer.anchorPoint = CGPointZero;
        
        [self.view.layer addSublayer:self.maskLayer];
    }
    
    // create a UIRefreshControl for reloading the data in the table with new facts
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor darkGrayColor];
    [refreshControl addTarget:self action:@selector(refreshTable:)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// refreshes the data in the table
- (void)refreshTable:(UIRefreshControl *)refreshControl
{
    // animate the MBProgressHUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // store the zip codes to refresh
    NSMutableArray *zipCodesTempArray = [[NSMutableArray alloc] init];
    for(City *city in self.mainModel.citiesArray)
    {
        [zipCodesTempArray addObject:city.zipCode];
    }
        
    // add all cities again with updated data
    for(NSString *city in zipCodesTempArray)
    {
        NSString *newCity = city;
        NSString *httpRequestURL = HTTP_REQUEST_URL;
        httpRequestURL = [httpRequestURL stringByAppendingString:newCity];
        httpRequestURL = [httpRequestURL stringByAppendingString:JSON_EXTENSION];
        
        [self httpRequestWithURL:httpRequestURL];
    }

    
    // reload the table
    [self.tableView reloadData];
    
    // disable the MBProgressHUD
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    // stop the refreshing animation
    [refreshControl endRefreshing];
}

#pragma mark - Adding city
- (IBAction)addCity:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add City" message:@"City, State OR Zip Code" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"San Francisco, CA";
    [alert addButtonWithTitle:@"Submit"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* detailString = [alertView textFieldAtIndex:0].text;
    NSLog(@"String is: %@", detailString); //Put it on the debugger
    if ([[alertView textFieldAtIndex:0].text length] <= 0 || buttonIndex == 0){
        return; //If cancel or 0 length string the string doesn't matter
    }
    
    if (buttonIndex == 1) {
        // Add city if valid
        
        NSString *httpRequestURL = HTTP_REQUEST_URL;
    
        // if entry was city
        if(![self hasLeadingNumberInString:detailString])
        {
            NSArray *subStrings = [detailString componentsSeparatedByString:@", "];
            NSString *newCity = [subStrings objectAtIndex:0];
            NSString *state = [subStrings objectAtIndex:1];
            
            NSString *backslash = @"/";
            NSString *modifiedCityString = [newCity stringByReplacingOccurrencesOfString:@" "
                                                                                 withString:@"_"];
            httpRequestURL = [httpRequestURL stringByAppendingString:backslash];
            httpRequestURL = [httpRequestURL stringByAppendingString:state];
            httpRequestURL = [httpRequestURL stringByAppendingString:backslash];
            httpRequestURL = [httpRequestURL stringByAppendingString:modifiedCityString];
            NSString *jsonTag = JSON_EXTENSION;
            httpRequestURL = [httpRequestURL stringByAppendingString:jsonTag];
        }
        // else if it was a zip code
        else
        {
            NSString *newCity = detailString;
            httpRequestURL = [httpRequestURL stringByAppendingString:newCity];
            NSString *jsonTag = JSON_EXTENSION;
            httpRequestURL = [httpRequestURL stringByAppendingString:jsonTag];
        }
        
        // add city to the model
        [self httpRequestWithURL:httpRequestURL];
    }
}

- (void)httpRequestWithURL:(NSString *)httpRequestURL
{
    // establish connection
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:httpRequestURL]];
    NSURLConnection *theConnection=[[NSURLConnection alloc]
                                    initWithRequest:theRequest delegate:self];
    if(theConnection){
        _currentCityWeatherData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"failed");
    }
}

// helper method for checking if first number in string is numeric
- (BOOL)hasLeadingNumberInString:(NSString*)str
{
    if (str)
        return [str length] && isnumber([str characterAtIndex:0]);
    else
        return NO;
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
    NSArray *results =  [rawParsedJson objectForKey:CURRENT_OBSERVATION_KEY];
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
        // pass in parsedJson into model
        NSArray *parsedJson =  [rawParsedJson objectForKey:CURRENT_OBSERVATION_KEY];
                
        [self.mainModel updateModelWithCity:parsedJson];
        
        // refresh cities array
        [self fetchCities];
        
        // reload the data
        [self.tableView reloadData];
    }
}

#pragma mark - Removing cities
// for swipe to remove
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.mainModel removeCityFromModel:[indexPath section]];
        
        // refresh cities
        [self fetchCities];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

// rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.mainModel.citiesArray count];
}

// columns
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // per city
    return 1;
}

// where you actually see the cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // CellIdentifier is a unique indentifier for each type of cell in this app
    static NSString *CellIdentifier = @"Cell";
    // get a cell for me - using Apple provided memory management (cache)
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    // visually
    cell.backgroundColor = [UIColor clearColor];
    UIView *backgroundView = (id)[cell viewWithTag:5];
    [backgroundView.layer setCornerRadius:7.0f];
    
    // disable selection color
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // get index of the cell
    NSInteger index = [indexPath section];
    
    // only fill in UI elements if data as been received
    if([self.mainModel.citiesArray count] > 0)
    {
    
        // get reference to UI elements on cell
        UILabel *cityLabel = (id)[cell viewWithTag:1];
        // set the text based on the section index
        //ESLCityData *currentCity = [self.mainModel.citiesArray objectAtIndex:index];
        City *currentCity = [self.mainModel.citiesArray objectAtIndex:index];
        NSString *cellCity = currentCity.cityName;
        cityLabel.text = cellCity;
        
        UILabel *temperatureLabel = (id)[cell viewWithTag:3];
        NSString *temperatureString = currentCity.weatherData.temperatureF;
        NSInteger temperatureInteger = [temperatureString integerValue];
        temperatureLabel.text = [NSString stringWithFormat:@"%ld°", temperatureInteger];
        
        UILabel *timeLabel = (id)[cell viewWithTag:6];
        NSString *timeString = currentCity.time;
        timeLabel.text = timeString;
        
        UIImageView *conditionImage = (id)[cell viewWithTag:4];
        conditionImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentCity.weatherData.icon]]];
        
        // highlight cell if it is the user's location
        if ([currentCity.zipCode isEqualToString:self.currentLocation]) {
            //backgroundView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        }
        
    }
    return cell;
}

// act on cell selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndex = [indexPath section];
    // advance to the next view
    [self performSegueWithIdentifier:@"Details" sender:self];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ESLDetailsViewController *vc =[segue destinationViewController];
    
    // set properties in the controller that store the data at the current index
    //ESLCityData *currentCity = [self.mainModel.citiesArray objectAtIndex:self.currentIndex];
    City *currentCity = [self.mainModel.citiesArray objectAtIndex:self.currentIndex];
    vc.city = currentCity.cityName;
    vc.time = currentCity.time;
    vc.condition = currentCity.weatherData.condition;
    NSString *temperatureString = currentCity.weatherData.temperatureF;
    NSInteger temperatureInteger = [temperatureString integerValue];
    vc.temperature = [NSString stringWithFormat:@"%ld°", temperatureInteger];
    vc.icon = currentCity.weatherData.icon;
    vc.windString = [NSString stringWithFormat:@"Wind: %@", currentCity.weatherData.wind];
    vc.humidityString = [NSString stringWithFormat:@"Humidity: %@", currentCity.weatherData.humidity];
    vc.feelsLike = [NSString stringWithFormat:@"Feels like: %@", currentCity.weatherData.feelsLike];
    vc.weatherEffect = currentCity.weatherData.weatherEffect;
}

@end
