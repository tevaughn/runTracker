//
//  locationManager.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "Run+Annotation.h"
#import "Breadcrumb+Annotation.h"

@interface Location : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Run *activeRun;
@property (strong, nonatomic) Breadcrumb *currentLocation;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (BOOL) checkAuthorization;
- (void) startLocationServices;


@end
