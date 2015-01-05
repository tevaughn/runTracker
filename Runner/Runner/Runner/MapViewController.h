//
//  MapViewController.h
//  Runner
//
//  Created by Administrator on 12/2/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Run.h"

@interface MapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) Run *run;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
