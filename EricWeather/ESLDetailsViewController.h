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

#define CLOUD_IMAGE_0 @"Cloud01.png"
#define CLOUD_IMAGE_1 @"Cloud03.png"

@interface ESLDetailsViewController : UIViewController

// various details that will be displayed
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *windString;
@property (nonatomic, strong) NSString *humidityString;
@property (nonatomic, strong) NSString *feelsLike;
@property (nonatomic, strong) NSString *weatherEffect;

// used for updating all the arrays at once
@property (nonatomic, strong) NSMutableArray *labelsArray;

@end
