//
//  RunLogCDTVC.h
//  Runner
//
//  Created by Administrator on 12/2/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface RunLogCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
