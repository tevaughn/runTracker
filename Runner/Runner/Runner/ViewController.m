//
//  ViewController.m
//  Runner
//
//  Created by Administrator on 10/28/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "WorkoutCDTVC.h"
#import "Location.h"
#import "RunStatsViewController.h"

@interface ViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *setWorkoutButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
 
@end

@implementation ViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = [NSPredicate predicateWithFormat:@"selected == true"]; // Get selected workout
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController performFetch:nil];
    
    if (![self.fetchedResultsController.fetchedObjects firstObject]) {
        Workout *workout  = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext: self.managedObjectContext];
        workout.name = @"None";
        workout.selected = [[NSNumber alloc] initWithBool:true];
        [self.fetchedResultsController performFetch:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
    
    
    self.workout = [self.fetchedResultsController.fetchedObjects firstObject];
    [self.setWorkoutButton setTitle:[[NSString alloc] initWithFormat: @"Workout: %@", self.workout.name] forState:UIControlStateNormal];
    
    // Make sure we have location authorization
    self.location = [[Location alloc] initWithManagedObjectContext:self.managedObjectContext];
    
    self.location.managedObjectContext = self.managedObjectContext;
    while (![self.location checkAuthorization]) {
        [self requestAlwaysAuthorization];
    }
    // Start location services
    [self.location startLocationServices];
    
}

- (void)contextChanges:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fetchedResultsController performFetch:nil];
        
        self.workout = [self.fetchedResultsController.fetchedObjects firstObject];
        
        [self.setWorkoutButton setTitle:[[NSString alloc] initWithFormat: @"Workout: %@", self.workout.name] forState:UIControlStateNormal];
    });

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.workout = [self.fetchedResultsController.fetchedObjects firstObject];
    [self.setWorkoutButton setTitle:[[NSString alloc] initWithFormat: @"Workout: %@", self.workout.name] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
    
}

- (void)viewWillDisappear:(BOOL)animated
{

    [[NSNotificationCenter defaultCenter] removeObserver:NSManagedObjectContextDidSaveNotification
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:self.managedObjectContext];
    [super viewWillDisappear:animated];
}

- (void)requestAlwaysAuthorization
{
    NSString *title;
    title = @"Location services are off or background location is not enabled";
    NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Settings", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        if([segue.identifier isEqualToString:@"fromGoRunViewToWorkoutTableView"]) {
            if ([segue.destinationViewController isKindOfClass:[WorkoutCDTVC class]]) {
                
                [segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
                }
        } else if([segue.identifier isEqualToString:@"fromGoRunViewToRunningView"]) {
                if ([segue.destinationViewController isKindOfClass:[RunStatsViewController class]]) {
                
                    Run *run = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:self.managedObjectContext];
                    [run initalizeRunForWorkout:((Workout *)[[self.fetchedResultsController fetchedObjects] firstObject])
                               forStartTime:CFAbsoluteTimeGetCurrent()
                              atCoordinates:self.mapView.userLocation.coordinate
                     inManagedObjectContext:self.managedObjectContext];
                    [segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
                    [segue.destinationViewController setRun:run];
                }
        }
    }
 
}

// when the mapView outlet gets set, set its delegate to ourself
- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    self.mapView.delegate = self;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView* annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:@"MyCustomAnnotation"];
    annotationView.image = [UIImage imageNamed:@"blue_circle"];
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{

    float spanX = 0.00125;
    float spanY = 0.00125;
    MKCoordinateRegion region;
    region.center.latitude = self.mapView.userLocation.coordinate.latitude;
    region.center.longitude = self.mapView.userLocation.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView setShowsUserLocation:YES];
}


@end
