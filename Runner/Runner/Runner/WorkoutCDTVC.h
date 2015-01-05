//
//  workoutCDTVC.h
//  Runner
//
//  Created by Administrator on 11/27/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Workout.h"

@interface WorkoutCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end
