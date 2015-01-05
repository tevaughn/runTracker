//
//  locationManager.m
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    
    if(self) {
        _managedObjectContext = managedObjectContext;
        
        // Create the location manager if this object does not
        // already have one.
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextChanges:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.managedObjectContext];
        
        
        self.currentLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Breadcrumb" inManagedObjectContext:self.managedObjectContext];
        
    }
    return self;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Run"];
    request.predicate = [NSPredicate predicateWithFormat:@"completed == false"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startTime"
                                                              ascending:YES
                                                               ]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController performFetch:nil];
    self.activeRun = [[self.fetchedResultsController fetchedObjects] firstObject];
}

- (void)contextChanges:(NSNotification *)notification
{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fetchedResultsController performFetch:nil];
        self.activeRun = [[self.fetchedResultsController fetchedObjects] firstObject];
    });
    

}

- (BOOL)checkAuthorization
{

    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied ){
        return false;
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        // The user has not enabled any location services. Request background authorization.
        [self.locationManager requestWhenInUseAuthorization];  // For foreground access
        [self.locationManager requestAlwaysAuthorization]; // For background access
        [self checkAuthorization];
    }
    
    return true;
}

- (void)startLocationServices
{
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // meters
    
    [self.locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     if (manager == self.locationManager )
     {

         if (self.activeRun) {
             for (CLLocation *location in locations) {
                 [Breadcrumb addBreadcrumbAtLocation:location OnRun:self.activeRun inManagedObjectContext:self.managedObjectContext];
             }
         }
         self.currentLocation.latitude = [NSNumber numberWithFloat:((CLLocation*)[locations lastObject]).coordinate.latitude];
         self.currentLocation.longitude = [NSNumber numberWithFloat:((CLLocation*)[locations lastObject]).coordinate.longitude];
         self.currentLocation.time = [[NSNumber alloc] initWithInteger:[((CLLocation*)[locations lastObject]).timestamp timeIntervalSince1970]];
     }
    [self.managedObjectContext save:nil];
}


@end
