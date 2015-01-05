//
//  RunLogCDTVC.m
//  Runner
//
//  Created by Administrator on 12/2/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "RunLogCDTVC.h"
#import "Run.h"
#import "Workout.h"
#import "WorkoutSummaryCDTVC.h"
#import "AppDelegate.h"

@interface RunLogCDTVC ()

@end

@implementation RunLogCDTVC


- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Run"];
    request.predicate = nil;//
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startTime"
                                                              ascending:NO]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
}

- (void)contextChanges:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
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
    id run = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Run Log Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[((Run *)run).startTime integerValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/MM/YYYY hh:mm:ss"];
    [dateFormat setTimeZone:timeZone];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    
    cell.textLabel.text = [[NSString alloc] initWithFormat: @"%@", dateString];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat: @"%@",((Run *)run).workout.name];
    
    return cell;
}



- (void)prepareWorkoutSummaryController:(WorkoutSummaryCDTVC *)workoutSummaryCDTVC ForRun:(Run *)run
{
    workoutSummaryCDTVC.run = run;
    workoutSummaryCDTVC.managedObjectContext = self.managedObjectContext;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if(indexPath){
        if([segue.identifier isEqualToString:@"fromRunTableToWorkoutSummaryTable"]){
            if ([segue.destinationViewController isKindOfClass:[WorkoutSummaryCDTVC class]]) {
                
                [self prepareWorkoutSummaryController:segue.destinationViewController
                                         ForRun:(id)[self.fetchedResultsController objectAtIndexPath:indexPath]];
                
            }
        }
    }
}


@end
