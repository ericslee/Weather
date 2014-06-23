//
//  ESLCoreDataManager.h
//  EricWeather
//
//  Created by Eric Lee on 6/23/14.
//  Copyright (c) 2014 EricInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "WeatherData.h"

@interface ESLCoreDataManager : NSObject

// Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (ESLCoreDataManager*)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
