//
//  WorkoutSummaryCDTVC.h
//  Runner
//
//  Created by Administrator on 12/2/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Run+Stats.h"

@interface WorkoutSummaryCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Run *run;

@end
