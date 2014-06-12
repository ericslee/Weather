//
//  ESLDetailsViewController.m
//  EricWeather
//
//  Created by Eric Lee on 6/10/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLDetailsViewController.h"

@interface ESLDetailsViewController ()

//@property (weak, nonatomic) IBOutlet SKView *particleBackground;

@property (nonatomic, strong) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UILabel *conditionLabel;
@property (nonatomic, strong) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, strong) IBOutlet UIImageView *weatherIcon;
@property (nonatomic, strong) IBOutlet UILabel *windStringLabel;
@property (nonatomic, strong) IBOutlet UILabel *humidityLabel;
@property (nonatomic, strong) IBOutlet UILabel *feelsLikeLabel;

@end

@implementation ESLDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
   
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ESLWeatherEffectsScene * scene = [ESLWeatherEffectsScene sceneWithSize:_particleBackground.bounds.size];
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    //[_particleBackground presentScene:scene];
    
    NSLog(@"%@", self.weatherEffect);
    
    // Determine what particle effect to play based on icon string in json
    // Rain
    if([self.weatherEffect isEqualToString:@"rain"] || [self.weatherEffect isEqualToString:@"chancerain"] || [self.weatherEffect isEqualToString:@"chancestorms"]
       || [self.weatherEffect isEqualToString:@"tstorms"])
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer blueGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        // effect
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer]; // 1
        emitterLayer.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.origin.y); // 2
        emitterLayer.emitterZPosition = 10; // 3
        emitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0); // 4
        emitterLayer.emitterShape = kCAEmitterLayerLine; // 5
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell]; // 6
        emitterCell.scale = 0.1; // 7
        emitterCell.scaleRange = 0.05; // 8
        emitterCell.emissionLongitude = 254.6;
        emitterCell.emissionRange = 0.2;
        emitterCell.lifetime = 8.0; // 10
        emitterCell.birthRate = 150; // 11
        emitterCell.velocity = 543.66; // 12
        emitterCell.velocityRange = 150; // 13
        emitterCell.yAcceleration = 150; // 14
        emitterCell.alphaRange = 0.0;
        emitterCell.color = [[UIColor colorWithRed:0.54 green:0.57 blue:1.0 alpha:0.8] CGColor];
        
        emitterCell.contents = (id)[[UIImage imageNamed:@"raindrop.png"] CGImage]; // 15
        emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell]; // 16
        
        [self.view.layer addSublayer:emitterLayer]; // 17
        
        // font
        _cityLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _conditionLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _temperatureLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _windStringLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _humidityLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _feelsLikeLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }
    
    // Snow
    else if([self.weatherEffect isEqualToString:@"chanceflurries"] || [self.weatherEffect isEqualToString:@"chancesleet"] || [self.weatherEffect isEqualToString:@"chancesnow"]
            || [self.weatherEffect isEqualToString:@"flurries"] || [self.weatherEffect isEqualToString:@"sleet"] || [self.weatherEffect isEqualToString:@"snow"])
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer snowGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        // effect
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer]; // 1
        emitterLayer.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.origin.y); // 2
        emitterLayer.emitterZPosition = 10; // 3
        emitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0); // 4
        emitterLayer.emitterShape = kCAEmitterLayerLine; // 5
        
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell]; // 6
        emitterCell.scale = 0.1; // 7
        emitterCell.scaleRange = 0.2; // 8
        emitterCell.emissionRange = (CGFloat)M_PI_2; // 9
        emitterCell.lifetime = 5.0; // 10
        emitterCell.birthRate = 20; // 11
        emitterCell.velocity = 200; // 12
        emitterCell.velocityRange = 50; // 13
        emitterCell.yAcceleration = 250; // 14
         
        emitterCell.contents = (id)[[UIImage imageNamed:@"spark.png"] CGImage]; // 15
        emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell]; // 16
        [self.view.layer addSublayer:emitterLayer]; // 17
        
        // font
        _cityLabel.textColor = [UIColor darkGrayColor];
        _conditionLabel.textColor = [UIColor darkGrayColor];
        _temperatureLabel.textColor = [UIColor darkGrayColor];
        _windStringLabel.textColor = [UIColor darkGrayColor];
        _humidityLabel.textColor = [UIColor darkGrayColor];
        _feelsLikeLabel.textColor = [UIColor darkGrayColor];
        
    }
    // Cloudy
    else if([self.weatherEffect isEqualToString:@"cloudy"] || [self.weatherEffect isEqualToString:@"fog"] || [self.weatherEffect isEqualToString:@"hazy"]
            || [self.weatherEffect isEqualToString:@"mostlycloudy"] || [self.weatherEffect isEqualToString:@"partlycloudy"] || [self.weatherEffect isEqualToString:@"partlysunny"])
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer cloudyGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        // effect
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer]; // 1
        emitterLayer.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer.emitterPosition = CGPointMake(self.view.bounds.size.width + 100, self.view.bounds.size.height / 2); // 2
        emitterLayer.emitterZPosition = 10; // 3
        emitterLayer.emitterSize = CGSizeMake(0, 500); // 4
        emitterLayer.emitterShape = kCAEmitterLayerCuboid; // 5
        
        CAEmitterLayer *emitterLayer2 = [CAEmitterLayer layer]; // 1
        emitterLayer2.backgroundColor = [[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        emitterLayer2.emitterPosition = CGPointMake(self.view.bounds.size.width + 100, self.view.bounds.size.height / 2); // 2
        emitterLayer2.emitterZPosition = 10; // 3
        emitterLayer2.emitterSize = CGSizeMake(0, 500); // 4
        emitterLayer2.emitterShape = kCAEmitterLayerCuboid; // 5
        
        // GO TO THE LEFT
        CAEmitterCell *emitterCell = [CAEmitterCell emitterCell]; // 6
        emitterCell.scale = 0.75; // 7
        emitterCell.scaleRange = 0.5; // 8
        emitterCell.emissionLatitude = 2;
        emitterCell.lifetime = 100.0; // 10
        emitterCell.birthRate = 0.05; // 11
        emitterCell.velocity = 10; // 12
        emitterCell.velocityRange = 50; // 13
        emitterCell.alphaRange = 0.2;
        //emitterCell.xAcceleration = -50;
        emitterCell.color = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
        emitterCell.contents = (id)[[UIImage imageNamed:@"Cloud01.png"] CGImage]; // 15

        // second cloud type
        // GO TO THE RIGHT
        CAEmitterCell *emitterCell2 = [CAEmitterCell emitterCell]; // 6
        emitterCell2.scale = 0.75; // 7
        emitterCell2.scaleRange = 0.5; // 8
        emitterCell.emissionLatitude = 2;
        emitterCell2.lifetime = 100.0; // 10
        emitterCell2.birthRate = 0.05; // 11
        emitterCell2.velocity = 10; // 12
        emitterCell2.velocityRange = 50; // 13
        emitterCell2.alphaRange = 0.2;
        emitterCell2.color = [[UIColor colorWithWhite:1.0 alpha:0.5] CGColor];
        emitterCell2.contents = (id)[[UIImage imageNamed:@"Cloud03.png"] CGImage]; // 15
        
        emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell]; // 16
        emitterLayer2.emitterCells = [NSArray arrayWithObject:emitterCell2]; // 16
        [self.view.layer addSublayer:emitterLayer]; // 17
        [self.view.layer addSublayer:emitterLayer2]; // 17
        
        // font
        _cityLabel.textColor = [UIColor darkGrayColor];
        _conditionLabel.textColor = [UIColor darkGrayColor];
        _temperatureLabel.textColor = [UIColor darkGrayColor];
        _windStringLabel.textColor = [UIColor darkGrayColor];
        _humidityLabel.textColor = [UIColor darkGrayColor];
        _feelsLikeLabel.textColor = [UIColor darkGrayColor];
    }
    // Sunny/default
    else
    {
        // background
        CAGradientLayer *bgLayer = [ESLBackgroundLayer sunnyGradient];
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        // effect
        
        // font
        _cityLabel.textColor = [UIColor darkGrayColor];
        _conditionLabel.textColor = [UIColor darkGrayColor];
        _temperatureLabel.textColor = [UIColor darkGrayColor];
        _windStringLabel.textColor = [UIColor darkGrayColor];
        _humidityLabel.textColor = [UIColor darkGrayColor];
        _feelsLikeLabel.textColor = [UIColor darkGrayColor];
    }
    // Snow
    
    _cityLabel.text = self.city;
    _conditionLabel.text = self.condition;
    _temperatureLabel.text = self.temperature;
    _weatherIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.icon]]];
    _windStringLabel.text = self.windString;
    _humidityLabel.text = self.humidityString;
    _feelsLikeLabel.text = self.feelsLike;
}

@end
