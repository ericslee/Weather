//
//  ESLDetailsViewController.h
//  EricWeather
//
//  Created by Eric Lee on 6/10/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESLWeatherDataManager.h"
#import <SpriteKit/SpriteKit.h>
#import "ESLBackgroundLayer.h"

@interface ESLDetailsViewController : UIViewController

// various details that will be displayed
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *windString;
@property (nonatomic, strong) NSString *humidityString;
@property (nonatomic, strong) NSString *feelsLike;
@property (nonatomic, strong) NSString *weatherEffect;

@end
