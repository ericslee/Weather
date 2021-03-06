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
    }
    
    return _mainModel;
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
    UIImage *backgroundImage = [UIImage imageNamed:@"bluesky_blur"];
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
    
    // register for notifications
    [self registerForNotifications];
    
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
    
    // store the cities to refresh
    self.tempCities = [[NSMutableArray alloc] initWithArray:self.mainModel.zipCodesArray];
    _mainModel = [[ESLWeatherDataManager alloc] initRefreshData:self.tempCities];
    
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
        
        NSString *httpRequestURL = @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/";
    
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
            NSString *jsonTag = @".json";
            httpRequestURL = [httpRequestURL stringByAppendingString:jsonTag];
        }
        // else if it was a zip code
        else
        {
            NSString *newCity = detailString;
            httpRequestURL = [httpRequestURL stringByAppendingString:newCity];
            NSString *jsonTag = @".json";
            httpRequestURL = [httpRequestURL stringByAppendingString:jsonTag];
        }
        
        // add city to the model
        [self.mainModel addCityToModel:httpRequestURL];
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

#pragma mark - Removing cities
// for swipe to remove
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here to do what you want when you hit delete
        //[itemArray removeObjectAtIndex:[indexPath row]];
        //[tableView reloadData];
        NSLog(@"Remove city from swipe");
        [self.mainModel removeCityFromModel:[self.mainModel.citiesArray objectAtIndex:[indexPath row]]];
    }
}

#pragma mark - Table view data source

// rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"%ld", _mainModel.numCities);
    return self.mainModel.numCities;
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
    //NSInteger index = [indexPath row];
    NSInteger index = [indexPath section];
    
    // only fill in UI elements if data as been received
    if([self.mainModel.citiesArray count] > 0)
    {
    
        // get reference to UI elements on cell
        UILabel *cityLabel = (id)[cell viewWithTag:1];
        // set the text based on the section index
        NSString *cellCity = [NSString stringWithFormat:@"%@", [self.mainModel.citiesArray objectAtIndex:index]];
        cityLabel.text = cellCity;
        
        UILabel *temperatureLabel = (id)[cell viewWithTag:3];
        NSString *temperatureString = [NSString stringWithFormat:@"%@°", [self.mainModel.temperatureStringDictionary objectForKey:cellCity]];
        NSInteger temperatureInteger = [temperatureString integerValue];
        temperatureLabel.text = [NSString stringWithFormat:@"%ld°", temperatureInteger];
        
        UIImageView *conditionImage = (id)[cell viewWithTag:4];
        conditionImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.mainModel.iconDictionary objectForKey:cellCity]]]];
        
    }
    return cell;
}

// act on cell selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.mainModel.currentIndex = [indexPath section];
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
    vc.city = [NSString stringWithFormat:@"%@", [self.mainModel.citiesArray objectAtIndex:self.mainModel.currentIndex]];
    vc.condition = [NSString stringWithFormat:@"%@", [self.mainModel.conditionsDictionary objectForKey:vc.city]];
    NSString *temperatureString = [NSString stringWithFormat:@"%@°", [self.mainModel.temperatureStringDictionary objectForKey:vc.city]];
    NSInteger temperatureInteger = [temperatureString integerValue];
    vc.temperature = [NSString stringWithFormat:@"%ld°", temperatureInteger];
    vc.icon = [NSString stringWithFormat:@"%@", [self.mainModel.iconDictionary objectForKey:vc.city]];
    vc.windString = [NSString stringWithFormat:@"Wind: %@", [self.mainModel.windStringDictionary objectForKey:vc.city]];
    vc.humidityString = [NSString stringWithFormat:@"Humidity: %@", [self.mainModel.humidityStringDictionary objectForKey:vc.city]];
    vc.feelsLike = [NSString stringWithFormat:@"Feels like: %@°", [self.mainModel.feelsLikeStringDictionary objectForKey:vc.city]];
    vc.weatherEffect = [NSString stringWithFormat:@"%@", [self.mainModel.weatherEffectsDictionary objectForKey:vc.city]];
}

#pragma mark - Notifications

// Notifications
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWeatherView:)
                                                 name:@"DataReceived"
                                               object:nil];
}

// notifcation function to update the table view cells
- (void)updateWeatherView:(NSNotification *)notification
{
    NSLog(@"Data updated");
    
    // reload the data
    [self.tableView reloadData];
}

@end
