//
//  MapViewController.m
//  Runner
//
//  Created by Administrator on 12/2/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController () <MKMapViewDelegate>


@end

@implementation MapViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Breadcrumb"];
    request.predicate = [NSPredicate predicateWithFormat:@"run == %@", self.run ];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time"
                                                              ascending:YES]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
    [self updateMap];
}

- (void)contextChanges:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fetchedResultsController performFetch:nil];
        [self updateMap];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
    [self.mapView addAnnotations:self.fetchedResultsController.fetchedObjects];
    [self.mapView showAnnotations:self.fetchedResultsController.fetchedObjects animated:YES];
    [self updateMap];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:NSManagedObjectContextDidSaveNotification
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:self.managedObjectContext];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [super viewWillDisappear:animated];
}

- (void)updateMap
{
    if ([self.fetchedResultsController.fetchedObjects firstObject]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:[self.fetchedResultsController.fetchedObjects lastObject]];
        });

    }

}


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

@end
