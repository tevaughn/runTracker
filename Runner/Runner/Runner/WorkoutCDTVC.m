//
//  workoutCDTVC.m
//  Runner
//
//  Created by Administrator on 11/27/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "WorkoutCDTVC.h"
#import "Workout.h"
#import "IntervalCDTVC.h"
#import "Workout+IntervalOrder.h"

@interface WorkoutCDTVC ()

@end

@implementation WorkoutCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Workout"];
    request.predicate = nil; // Get all workouts alphabetically
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    

    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

}

- (void)contextChanges:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id workout = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Workout Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = ((Workout *)workout).name;
    
    // If selected, indicate with a check mark
    if ( [((Workout *)workout).selected boolValue] ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}



- (void)prepareIntervalViewController:(IntervalCDTVC *)intervalCDTVC forWorkout:(Workout *)workout
{
    intervalCDTVC.workout = workout;
    [intervalCDTVC.workout selectWorkoutFromWorkouts:self.fetchedResultsController.fetchedObjects];
}

- (void)prepareIntervalViewControllerForNewWorkout:(IntervalCDTVC *)intervalCDTVC
{

    [self.managedObjectContext performBlockAndWait:^(void) {
        intervalCDTVC.workout  = [NSEntityDescription insertNewObjectForEntityForName:@"Workout" inManagedObjectContext:self.managedObjectContext];
        intervalCDTVC.workout.name = @"New Workout";
        [intervalCDTVC.workout selectWorkoutFromWorkouts:self.fetchedResultsController.fetchedObjects];
    }];
    
    [self.managedObjectContext save:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath){
            if([segue.identifier isEqualToString:@"fromWorkoutTableToIntervalView"]){
                if ([segue.destinationViewController isKindOfClass:[IntervalCDTVC class]]) {
                    
                    [self prepareIntervalViewController:segue.destinationViewController
                                       forWorkout:(id)[self.fetchedResultsController objectAtIndexPath:indexPath]];
                    
                }
            }
        }
    } else if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        if([segue.identifier isEqualToString:@"fromNewWorkoutToIntervalView"]){
            if ([segue.destinationViewController isKindOfClass:[IntervalCDTVC class]]) {
                
                [self prepareIntervalViewControllerForNewWorkout:segue.destinationViewController];
                
            }
        }
    }
}


@end

