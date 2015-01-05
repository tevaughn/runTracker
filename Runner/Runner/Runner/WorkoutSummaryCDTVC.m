//
//  WorkoutSummaryCDTVC.m
//  Runner
//
//  Created by Administrator on 12/2/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "WorkoutSummaryCDTVC.h"
#import "MapViewController.h"
#import "IntervalRecord.h"
#import "Workout.h"

@interface WorkoutSummaryCDTVC ()

@end

@implementation WorkoutSummaryCDTVC

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"IntervalRecord"];
    request.predicate = [NSPredicate predicateWithFormat:@"run == %@", self.run ];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order"
                                                              ascending:YES]];
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
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
    

    [[self navigationController] navigationBar].topItem.title = [[NSString alloc] initWithFormat:@"%@",self.run.workout.name];
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
    IntervalRecord* intervalRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Workout Summary Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if ([intervalRecord.order integerValue] >= [self.run.currentInterval integerValue]) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.textColor = [UIColor redColor];
    } else if ([intervalRecord.order integerValue] == [self.run.currentInterval integerValue] - 1) {
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.textColor = [UIColor blueColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    
    cell.textLabel.text = [[NSString alloc] initWithFormat: @"%@",[self timeStringForTimeInSeconds: [((IntervalRecord *)intervalRecord).timeInS integerValue]]];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat: @"%@ km",[self distanceStringForDistanceInKm:[((IntervalRecord *)intervalRecord).distanceInKm integerValue]]];
    
    return cell;
}



- (void)prepareMapViewController:(MapViewController *)mapViewController
{
    mapViewController.run = self.run;
    mapViewController.managedObjectContext = self.managedObjectContext;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        if([segue.identifier isEqualToString:@"fromWorkoutSummaryToMap"]){
            if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
                
                [self prepareMapViewController:segue.destinationViewController];
                
            }
        }
    }
}

- (IBAction)didPressDoneButton:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (NSString*)timeStringForTimeInSeconds:(NSInteger)timeInSeconds
{
    NSInteger minutes = timeInSeconds / 60 ;
    NSInteger seconds = timeInSeconds - (minutes * 60);
    
    return [NSString stringWithFormat:@"%01ld:%02ld", (long)minutes, (long)seconds];
    
}

- (NSString*)distanceStringForDistanceInKm:(NSInteger)distanceInM
{
    NSInteger kiloMeters = distanceInM / 1000 ;
    NSInteger meters = distanceInM - (kiloMeters * 1000);
    
    return [NSString stringWithFormat:@"%01ld.%03ld", (long)kiloMeters, (long)meters];
}



@end
