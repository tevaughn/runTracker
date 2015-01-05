//
//  IntervalViewController.h
//  Runner
//
//  Created by Administrator on 11/27/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Workout.h"

@interface IntervalCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Workout *workout;

@end
