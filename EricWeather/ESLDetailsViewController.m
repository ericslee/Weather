//
//  ESLDetailsViewController.m
//  EricWeather
//
//  Created by Eric Lee on 6/10/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLDetailsViewController.h"

@interface ESLDetailsViewController ()

@property (nonatomic, strong) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *conditionLabel;
@property (nonatomic, strong) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, strong) IBOutlet UIImageView *weatherIcon;
@property (nonatomic, strong) IBOutlet UILabel *windStringLabel;
@property (nonatomic, strong) IBOutlet UILabel *humidityLabel;
@property (nonatomic, strong) IBOutlet UILabel *feelsLikeLabel;

@end

@implementation ESLDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Determine what particle effect to play based on icon string in json
    [self determineWeatherEffect];
    
    // set the text for all the labels in the detail view
    self.cityLabel.text = self.city;
    self.timeLabel.text = self.time;
    self.conditionLabel.text = self.condition;
    self.temperatureLabel.text = self.temperature;
    self.weatherIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.icon]]];
    self.windStringLabel.text = self.windString;
    self.humidityLabel.text = self.humidityString;
    self.feelsLikeLabel.text = self.feelsLike;
}

// Set the background, text color, and particle effect based on the icon string
- (void)determineWeatherEffect
{
    // Rain
    if([self.weatherEffect isEqualToString:@"rain"] || [self.weatherEffect isEqualToString:@"chancerain"] || [self.weatherEffect isEqualToString:@"chancestorms"]
       || [self.weatherEffect isEqualToString:@"tstorms"])
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer rainGradient];
        [self setBackground:bgLayer];
        
        // effect
        [self setEffect:@"rain"];
        
        // font
        [self setFont:[UIColor colorWithWhite:0.9 alpha:1.0]];
    }
    
    // Snow
    else if([self.weatherEffect isEqualToString:@"chanceflurries"] || [self.weatherEffect isEqualToString:@"chancesleet"] || [self.weatherEffect isEqualToString:@"chancesnow"]
            || [self.weatherEffect isEqualToString:@"flurries"] || [self.weatherEffect isEqualToString:@"sleet"] || [self.weatherEffect isEqualToString:@"snow"])
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer snowGradient];
        [self setBackground:bgLayer];
        
        // effect
        [self setEffect:@"snow"];
        
        // font
        [self setFont:[UIColor darkGrayColor]];
        
    }
    // Cloudy
    else if([self.weatherEffect isEqualToString:@"cloudy"] || [self.weatherEffect isEqualToString:@"fog"] || [self.weatherEffect isEqualToString:@"hazy"]
            || [self.weatherEffect isEqualToString:@"mostlycloudy"] || [self.weatherEffect isEqualToString:@"partlycloudy"] || [self.weatherEffect isEqualToString:@"partlysunny"])
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer cloudyGradient];
        [self setBackground:bgLayer];
        
        // effect
        [self setEffect:@"cloudy"];
        
        // font
        [self setFont:[UIColor darkGrayColor]];
    }
    // Sunny/default
    else
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer sunnyGradient];
        [self setBackground:bgLayer];
        
        // effect
        [self setEffect:@"sunny"];
        
        // font
        [self setFont:[UIColor darkGrayColor]];
    }
}

- (void)setBackground:(CAGradientLayer *)gradient
{
    gradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)setFont:(UIColor *)fontColor
{
    self.cityLabel.textColor = fontColor;
    self.timeLabel.textColor = fontColor;
    self.conditionLabel.textColor = fontColor;
    self.temperatureLabel.textColor = fontColor;
    self.windStringLabel.textColor = fontColor;
    self.humidityLabel.textColor = fontColor;
    self.feelsLikeLabel.textColor = fontColor;
}

- (void)setEffect:(NSString *)effect
{
    if ([effect isEqualToString:@"rain"]) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        emitterLayer.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.origin.y);
        emitterLayer.emitterZPosition = 10;
        emitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
        emitterLayer.emitterShape = kCAEmitterLayerLine;
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.scale = 0.1;
        emitterCell.scaleRange = 0.05;
        emitterCell.emissionLongitude = 254.6;
        emitterCell.emissionRange = 0.2;
        emitterCell.lifetime = 8.0;
        emitterCell.birthRate = 150;
        emitterCell.velocity = 543.66;
        emitterCell.velocityRange = 150;
        emitterCell.yAcceleration = 150;
        emitterCell.alphaRange = 0.0;
        emitterCell.color = [[UIColor colorWithRed:0.54 green:0.57 blue:1.0 alpha:0.8] CGColor];
        
        emitterCell.contents = (id)[[UIImage imageNamed:@"raindrop.png"] CGImage];
        emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
        
        [self.view.layer addSublayer:emitterLayer];
    }
    else if ([effect isEqualToString:@"snow"]) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        emitterLayer.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.origin.y);
        emitterLayer.emitterZPosition = 10; // 3
        emitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
        emitterLayer.emitterShape = kCAEmitterLayerLine;
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.scale = 0.1;
        emitterCell.scaleRange = 0.2;
        emitterCell.emissionRange = (CGFloat)M_PI_2;
        emitterCell.lifetime = 5.0;
        emitterCell.birthRate = 20;
        emitterCell.velocity = 200;
        emitterCell.velocityRange = 50;
        emitterCell.yAcceleration = 250;
        
        emitterCell.contents = (id)[[UIImage imageNamed:@"spark.png"] CGImage];
        emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
        [self.view.layer addSublayer:emitterLayer];
    }
    else if ([effect isEqualToString:@"cloudy"]) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        emitterLayer.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width + 100, self.view.bounds.size.height / 2);
        emitterLayer.emitterZPosition = 10;
        emitterLayer.emitterSize = CGSizeMake(0, 500);
        emitterLayer.emitterShape = kCAEmitterLayerCuboid;
        
        CAEmitterLayer *emitterLayer2 = [CAEmitterLayer layer];
        emitterLayer2.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer2.emitterPosition = CGPointMake(self.view.bounds.size.width + 100, self.view.bounds.size.height / 2);
        emitterLayer2.emitterZPosition = 10;
        emitterLayer2.emitterSize = CGSizeMake(0, 500);
        emitterLayer2.emitterShape = kCAEmitterLayerCuboid;
        
        // GO TO THE LEFT
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
        emitterCell.scale = 0.75;
        emitterCell.scaleRange = 0.5;
        emitterCell.emissionLatitude = 2;
        emitterCell.lifetime = 100.0;
        emitterCell.birthRate = 0.05;
        emitterCell.velocity = 10;
        emitterCell.velocityRange = 50;
        emitterCell.alphaRange = 0.2;
        emitterCell.color = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
        emitterCell.contents = (id)[[UIImage imageNamed:CLOUD_IMAGE_0] CGImage];
        
        // second cloud type
        // GO TO THE RIGHT
        CAEmitterCell *emitterCell2 = [CAEmitterCell emitterCell];
        emitterCell2.scale = 0.75;
        emitterCell2.scaleRange = 0.5;
        emitterCell.emissionLatitude = 2;
        emitterCell2.lifetime = 100.0;
        emitterCell2.birthRate = 0.05;
        emitterCell2.velocity = 10;
        emitterCell2.velocityRange = 50;
        emitterCell2.alphaRange = 0.2;
        emitterCell2.color = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
        emitterCell2.contents = (id)[[UIImage imageNamed:CLOUD_IMAGE_1] CGImage];
        
        emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
        emitterLayer2.emitterCells = [NSArray arrayWithObject:emitterCell2];
        [self.view.layer addSublayer:emitterLayer];
        [self.view.layer addSublayer:emitterLayer2];
    }
    else {
        // no effect at the moment
    }
}

@end
