//
//  ESLViewController.h
//  EricWeather
//
//  Created by Eric Lee on 6/5/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//
//  Controller that populates the model from the wunderground json and fills in
//  this data into the cells of the view

#import <UIKit/UIKit.h>
#import "ESLWeatherDataManager.h"
#import "ESLBackgroundLayer.h"
#import "ESLDetailsViewController.h"
#import "MBProgressHUD.h"

#define HTTP_REQUEST_URL @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/"
#define SFO_URL @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/94107.json"
#define BACKGROUND_IMAGE_URL @"bluesky_blur"

@interface ESLViewController : UITableViewController

// for gradients in the table view
@property (nonatomic,strong) CAGradientLayer *maskLayer;
// stores all of the weather data
@property (nonatomic, strong) ESLWeatherDataManager *mainModel;
// temp data for storing the raw json
@property (nonatomic, strong) NSMutableData *currentCityWeatherData;
// current cell index, used for selecting appropriate city to load data for in the detail view
@property (nonatomic) NSInteger currentIndex;
// user's current city by location for highlighting purposes
@property (nonatomic, strong) NSString *currentLocation;

// add city
- (IBAction)addCity:(id)sender;

@end