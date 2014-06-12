//
//  ESLWeatherEffectsScene.m
//  EricWeather
//
//  Created by Eric Lee on 6/10/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLWeatherEffectsScene.h"

@implementation ESLWeatherEffectsScene

-(id)initWithSize:(CGSize)size {
    
    // rain
    if (self = [super initWithSize:size]) {
        //self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
        SKEmitterNode *rain = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        rain.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height);
        rain.name = @"particleRain";
        rain.targetNode = self.scene;
        [self addChild:rain];
    }
    return self;
}

@end
