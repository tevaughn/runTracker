//
//  ViewController.h
//  Runner
//
//  Created by Administrator on 10/28/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//


// We are a subclass of core data table view controller because we need the core data functionality
#import "CoreDataViewController.h"
#import "Location.h"
#import "Workout.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) Workout* workout;


@end

