//
//  IntervalViewController.m
//  Runner
//
//  Created by Administrator on 11/27/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "IntervalCDTVC.h"
#import "Interval.h"
#import "IntervalEditTVC.h"
#import "Workout+IntervalOrder.h"


@interface IntervalCDTVC ()

@property (weak, nonatomic) IBOutlet UITextField *workoutNameTextField;

@end

@implementation IntervalCDTVC


- (void)setWorkout:(Workout *)workout
{
    _workout = workout;
    self.workoutNameTextField.text = workout.name;
    [self setManagedObjectContext:workout.managedObjectContext];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Interval"];

    request.predicate = [NSPredicate predicateWithFormat:@"workout.name == %@", self.workout.name];

    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order"
                                                              ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (void)contextChanges:(NSNotification *)notification
{
    // Update view
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self fetchedResultsController]) {
        [[self fetchedResultsController] performFetch:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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

- (IBAction)didUpdateWorkoutName:(id)sender {
    
    [self.managedObjectContext performBlockAndWait:^(void) {
         self.workout.name = self.workoutNameTextField.text;
    [self.managedObjectContext save:nil];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    id interval = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"Interval Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setNeedsLayout];
    
    if ([((Interval *)interval).typeDistanceOrTime isEqualToString:@"Time"]) {
        
        NSInteger minutes = [((Interval *)interval).lengthInKmOrSeconds integerValue] / 60 ;

        NSInteger seconds = [((Interval *)interval).lengthInKmOrSeconds integerValue] - (minutes * 60);


        cell.textLabel.text = [NSString stringWithFormat:@"%01ld:%02ld", (long)minutes, (long)seconds];
        cell.detailTextLabel.text = ((Interval *)interval).pace;

    } else if ([((Interval *)interval).typeDistanceOrTime isEqualToString:@"Distance"]) {
        
        NSInteger kiloMeters = [((Interval *)interval).lengthInKmOrSeconds integerValue] / 1000 ;
        NSInteger meters = [((Interval *)interval).lengthInKmOrSeconds integerValue] - (kiloMeters * 1000);
        
        cell.textLabel.text = [NSString stringWithFormat:@"%01ld.%03ld", (long)kiloMeters, (long)meters];
        cell.detailTextLabel.text = ((Interval *)interval).pace;
    
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    return cell;
}


- (void)prepareIntervalTVC:(IntervalEditTVC *)intervalEditTVC forInterval:(id)interval
{
    intervalEditTVC.interval = (Interval *)interval;
}

// Create a new interval to edit. Create default settings
- (void)prepareIntervalTVCForNewInterval:(IntervalEditTVC *)intervalEditTVC
{
    [self.managedObjectContext performBlockAndWait:^(void){
        
        Interval* interval  = [NSEntityDescription insertNewObjectForEntityForName:@"Interval" inManagedObjectContext:self.managedObjectContext];
        interval.typeDistanceOrTime = @"Distance";
        interval.pace = @"Slow";
        interval.lengthInKmOrSeconds = [[NSNumber alloc] initWithInteger:0];
        
        intervalEditTVC.interval = interval;
        
        // Add new interval
        // Due to know apple bug, use this workaround:
        [self.workout addIntervalToEndOfWorkout:intervalEditTVC.interval];
        
    }];
    
    //[self.managedObjectContext save:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath){
            if([segue.identifier isEqualToString:@"fromIntervalTableToIntervalEditView"]){
                if ([segue.destinationViewController isKindOfClass:[IntervalEditTVC class]]) {
                    
                    [self prepareIntervalTVC:segue.destinationViewController
                                 forInterval:[self.fetchedResultsController objectAtIndexPath:indexPath]];
                }
            }
        }
    } else if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        if([segue.identifier isEqualToString:@"fromIntervalBarItemToIntervalEditView"]){
            if ([segue.destinationViewController isKindOfClass:[IntervalEditTVC class]]) {
                
                [self prepareIntervalTVCForNewInterval:segue.destinationViewController];
                
            }
        }
    }
}

@end
