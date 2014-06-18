//
//  ESLViewController.h
//  EricWeather
//
//  Created by Eric Lee on 6/5/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESLWeatherDataManager.h"
#import "ESLBackgroundLayer.h"
#import "ESLDetailsViewController.h"
#import "MBProgressHUD.h"

#define SFO_URL @"http://api.wunderground.com/api/bcc62b913a4abd44/conditions/forecast/q/94107.json"

@interface ESLViewController : UITableViewController

@property (nonatomic,strong) CAGradientLayer *maskLayer; // for gradients in the table view
@property (nonatomic, strong) ESLWeatherDataManager *mainModel; // stores all of the weather data

@property (nonatomic, strong) NSMutableData *currentCityWeatherData;
@property (nonatomic, strong) NSMutableArray *tempCities;

// add city
- (IBAction)addCity:(id)sender;

@end