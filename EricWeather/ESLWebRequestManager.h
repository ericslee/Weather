//
//  ESLWebRequestManager.h
//  EricWeather
//
//  Created by Eric Lee on 6/6/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//
//  Part of model that handles web requests and provides methods to return data or JSON from the web
//  Abstracted for use with various apps

#import <Foundation/Foundation.h>

@interface ESLWebRequestManager : NSObject

// check if device is connected to the internet
+ (BOOL)doesHaveInternetConnection;

// static method that returns data from the input url
+ (NSData *)dataFromURL:(NSURL *)url;
+ (NSData *)dataFromString:(NSString *)urlString;

@end
