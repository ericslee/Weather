//
//  ESLWebRequestManager.m
//  EricWeather
//
//  Created by Eric Lee on 6/6/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import "ESLWebRequestManager.h"
#import "Reachability.h"

@implementation ESLWebRequestManager

// run code from Apple reachability code to determine internet connectivity
+ (BOOL)doesHaveInternetConnection
{
    // check for network access using Apple Reachability
    // get reachability object
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    
    // check current reachability status
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    return (networkStatus == NotReachable) ? NO : YES;
}

// return data from the input url
+ (NSData *)dataFromURL:(NSURL *)url
{
    // check to see if we have internet
    if (![ESLWebRequestManager doesHaveInternetConnection]) {
        // present an alert if not connected to internet
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"Not Connected to Internet"
                                                       delegate:self
                                              cancelButtonTitle:@"Check your connection and try again."
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return nil;
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *urlResponse;
    NSError *urlError;
    // raw data
    NSData *urlData = [NSURLConnection
                       sendSynchronousRequest:urlRequest
                       returningResponse:&urlResponse
                       error:&urlError];
    
    return urlData;
}

// wrapper around dataFromURL that can take in a string
+ (NSData *)dataFromString:(NSString *)urlString
{
    return [ESLWebRequestManager dataFromURL:[NSURL URLWithString:urlString]];
}

@end
