//
//  ESLViewController.m
//  EricWeather
//
//  Created by Eric Lee on 6/5/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLViewController.h"

@interface ESLViewController ()

@end

@implementation ESLViewController

// lazy instantiation for main model
- (ESLWeatherDataManager *)mainModel
{
    if (!_mainModel) {
        // animate the MBProgressHUD
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        _mainModel = [[ESLWeatherDataManager alloc] initDefault];
        
         //NSData *profileData = [ESLWebRequestManager dataFromString:SFO_URL];
         //_mainModel = [[ESLWeatherDataManager alloc] initWithNSData:_responseData];
        
        // disable the MBProgressHUD
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    return _mainModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
    CAGradientLayer *bgLayer = [ESLBackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    //bgLayer.frame = self.view.
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    */
    
    //[super viewWillAppear:animated];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
    //self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.tableView.backgroundView.alpha = 1.0;
    //self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.opaque = NO;
    
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
        /*
         self.maskLayer.bounds = CGRectMake(0, 0,
         self.tableView.frame.size.width,
         self.tableView.frame.size.height);*/
        self.maskLayer.anchorPoint = CGPointZero;
        
        [self.view.layer addSublayer:self.maskLayer];
    }
    
    // register for notifications
    [self registerForNotifications];
    
    // create a UIRefreshControl for reloading the data in the table with new facts
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshTable:)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

// refreshes the data in the table
- (void)refreshTable:(UIRefreshControl *)refreshControl
{
    // get new JSON table to pull from
    _mainModel = [[ESLWeatherDataManager alloc] initDefault];
    
    //TODO: specific initializer for refreshing
    
    // add all previous cities too
    
    // reload the table
    [self.tableView reloadData];
    
    // stop the refreshing animation
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCity:(id)sender
{
    NSLog(@"Add city");
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Add City" message:@"Zip Code" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Submit"];
    [alert show];
    
    /*
    NSString *newCity = @"30189";
    NSString *httpRequestURL = @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/";
    httpRequestURL = [httpRequestURL stringByAppendingString:newCity];
    NSString *jsonTag = @".json";
    httpRequestURL = [httpRequestURL stringByAppendingString:jsonTag];
    
    // add city to the model
    [self.mainModel addCityToModel:httpRequestURL];
     */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* detailString = [alertView textFieldAtIndex:0].text;
    NSLog(@"String is: %@", detailString); //Put it on the debugger
    if ([[alertView textFieldAtIndex:0].text length] <= 0 || buttonIndex == 0){
        return; //If cancel or 0 length string the string doesn't matter
    }
    
    if (buttonIndex == 1) {
        // Add city if valid
        NSLog(@"valid button click");
        
        NSString *newCity = detailString;
        NSString *httpRequestURL = @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/";
        httpRequestURL = [httpRequestURL stringByAppendingString:newCity];
        NSString *jsonTag = @".json";
        httpRequestURL = [httpRequestURL stringByAppendingString:jsonTag];
        
        // add city to the model
        [self.mainModel addCityToModel:httpRequestURL];
    }
}

#pragma mark - Table view data source

// rows
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"%ld", _mainModel.numCities);
    return self.mainModel.numCities;
    //return 5;
}

// columns
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // per fact/number
    //return self.mainModel.numKeys;
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
    //[cell.layer setCornerRadius:7.0f];
    //[cell.layer setMasksToBounds:YES];
    //[cell.layer setBackgroundColor:[U]]
    //[cell.layer setBorderWidth:2.0f];
    //[cell.layer setBorderColor:[[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.1] CGColor]];
    //cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.1];
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
    
        //UILabel *weatherLabel = (id)[cell viewWithTag:2];
        //weatherLabel.text = [NSString stringWithFormat:@"%@", [self.mainModel.conditionsDictionary objectForKey:cellCity]];
        
        UILabel *temperatureLabel = (id)[cell viewWithTag:3];
        NSString *temperatureString = [NSString stringWithFormat:@"%@°", [self.mainModel.temperatureStringDictionary objectForKey:cellCity]];
        NSInteger temperatureInteger = [temperatureString integerValue];
        temperatureLabel.text = [NSString stringWithFormat:@"%ld°", temperatureInteger];
        
        UIImageView *conditionImage = (id)[cell viewWithTag:4];
        conditionImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.mainModel.iconDictionary objectForKey:cellCity]]]];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.mainModel.currentIndex = [indexPath section];
    // advance to the next view
    [self performSegueWithIdentifier:@"Details" sender:self];
}

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

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateWeatherView:)
                                                 name:@"DataReceived"
                                               object:nil];
}

- (void)updateWeatherView:(NSNotification *)notification
{
    NSLog(@"Data updated");
    
    // reload the data
    [self.tableView reloadData];
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

@end
