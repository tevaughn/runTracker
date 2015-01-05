//
//  runStatsViewController.m
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "RunStatsViewController.h"
#import "Interval+Order.h"
#import "Workout+IntervalOrder.h"
#import "WorkoutSummaryCDTVC.h"
#import "MapViewController.h"

@interface RunStatsViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *intervalDistanceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *intervalTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *intervalPaceCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *totalDistanceCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *totalTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *totalPaceCell;

@property (weak, nonatomic) NSTimer *secondTimer;
@property (weak, nonatomic) NSTimer *intervalTimer;

@end

@implementation RunStatsViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Interval"];
    request.predicate = [NSPredicate predicateWithFormat:@"workout.name == %@", self.run.workout.name];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order"
                                                              ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController performFetch:nil];

    self.intervals = [[NSMutableArray alloc] initWithArray:
    [self.fetchedResultsController fetchedObjects]];
    
    // Every second, update my view
    if (!_secondTimer) {
        self.secondTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
    }
    
    if (!_synthesizer) {
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        [self playStatusForNewInterval:[self.intervals firstObject]];
    }

}

- (void)updateView{
    
    NSInteger intervalLength;
    NSString *intervalType;
    
    NSInteger count = [self.run.currentInterval integerValue];
    
    // We either have no workout or we've "finished" our workout
    if (count == [self.intervals count]) {
        // If we haven't created the record for the "last" interval, do so
        if ([self.run.intervalRecords count] == count) {
            [self.run insertFinalIntervalAtCount:count];
        }
        
        intervalType = nil;
        intervalLength = INFINITY;
        
    } else {
    
        intervalLength = [((Interval *)[self.intervals objectAtIndex:count]).lengthInKmOrSeconds integerValue];
        intervalType = ((Interval *)[self.intervals objectAtIndex:count]).typeDistanceOrTime;
    }
    
    NSInteger intervalTime = [self.run getIntervalTimeForIntervalCount:count];
    NSInteger intervalDistance = [self.run getIntervalDistanceForIntervalCount:count];
    
    // Update the status of the counters
    self.totalDistanceCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ km",[self distanceStringForDistanceInKm:[self.run getCurrentRunDistaceInMeters]]];
    self.totalTimeCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@",[self timeStringForTimeInSeconds:[self.run getCurrentRunTimeInSeconds]]];
    self.totalPaceCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ per km",( [self.run getCurrentPaceInSecondsPerKM] ? [self timeStringForTimeInSeconds:[self.run getCurrentPaceInSecondsPerKM]] : @"-:--")];
    
    self.intervalDistanceCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ km",[self distanceStringForDistanceInKm:[self.run getIntervalDistanceForIntervalCount:count]]];
    self.intervalTimeCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@",[self timeStringForTimeInSeconds:[self.run getIntervalTimeForIntervalCount:count]]];
    self.intervalPaceCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ per km",( [self.run getIntervalAvgPaceInSecondsPerKMForIntervalCount:count] ? [self timeStringForTimeInSeconds:[self.run getIntervalAvgPaceInSecondsPerKMForIntervalCount:count]] :  @"-:--") ];
    
    if ([intervalType isEqualToString:@"Time"]) {
        if (intervalTime >= intervalLength) {
            [self.run currentIntervalCompleted];
            
            if ([self.run.currentInterval integerValue] == [self.intervals count]) {
                [self playStatusForWorkoutComplete];
            } else {
                [self playStatusForNewInterval:[self.intervals objectAtIndex:[self.run.currentInterval integerValue]]];
            }
        }
    } else if ([intervalType isEqualToString:@"Distance"]) {
        if (intervalDistance >= intervalLength) {
            [self.run currentIntervalCompleted];
            
            if ([self.run.currentInterval integerValue] == [self.intervals count]) {
                [self playStatusForWorkoutComplete];
            } else {
                [self playStatusForNewInterval:[self.intervals objectAtIndex:[self.run.currentInterval integerValue]]];
            }
        }
    }
    
}


#pragma mark - Audio

-(void)playStatusForNewInterval:(Interval*)interval{
    
    NSInteger intervalLength = [interval.lengthInKmOrSeconds integerValue];
    NSString *intervalType = interval.typeDistanceOrTime;
    NSString *intervalPace = interval.pace;
    NSString *length;
    
    AVSpeechUtterance *status;
    
    if ([intervalType isEqualToString:@"Time"]) {
        NSInteger minutes = intervalLength / 60 ;
        NSInteger seconds = intervalLength - (minutes * 60);
        NSString *minuteString;
        NSString *secondString;
        
        if (minutes == 1 ) {
            minuteString = @"minute";
        } else {
            minuteString = @"minutes";
        }
        
        if (seconds == 1 ) {
            secondString = @"second";
        } else {
            secondString = @"seconds";
        }
        
        length = [[NSString alloc] initWithFormat:@"%01ld %@ and %01ld %@", (long)minutes, minuteString, (long)seconds, secondString ];
    } else if ([intervalType isEqualToString:@"Distance"]) {
        NSInteger kiloMeters = intervalLength / 1000 ;
        NSInteger meters = intervalLength - (kiloMeters * 1000);
        NSString *kilometerString;
        NSString *meterString;
        
        if (kiloMeters == 1 ) {
            kilometerString = @"kilometer";
        } else {
            kilometerString = @"kilometers";
        }
        
        if (meters == 1 ) {
            meterString = @"meter";
        } else {
            meterString = @"meters";
        }
        
        length = [[NSString alloc] initWithFormat:@"%01ld %@ and %01ld %@", (long)kiloMeters, kilometerString, (long)meters, meterString];
    } else if (!interval) {
        length = @"";
        intervalPace = @"";
    }
    
    status = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat:@"Begin next Interval. %@. %@", length, intervalPace]];

    status.rate = AVSpeechUtteranceMinimumSpeechRate;
    
    [self.synthesizer speakUtterance:status];
    
}

- (void)playStatusForWorkoutComplete
{
    AVSpeechUtterance *status = [[AVSpeechUtterance alloc] initWithString:[NSString stringWithFormat:@"Workout Complete"]];
    
    status.rate = AVSpeechUtteranceMinimumSpeechRate;
    
    [self.synthesizer speakUtterance:status];
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

- (void)prepareMapViewController:(MapViewController *)mapViewController
{
    mapViewController.run = self.run;
    mapViewController.managedObjectContext = self.managedObjectContext;
}

- (void)prepareWorkoutSummaryController:(WorkoutSummaryCDTVC *)workoutSummaryCDTVC
{
    [self.run workoutCompleted];
    workoutSummaryCDTVC.run = self.run;
    workoutSummaryCDTVC.managedObjectContext = self.managedObjectContext;
    [self.secondTimer invalidate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        if([segue.identifier isEqualToString:@"fromWorkoutToWorkoutSummary"]){
            if ([segue.destinationViewController isKindOfClass:[WorkoutSummaryCDTVC class]]) {
                
                [self prepareWorkoutSummaryController:segue.destinationViewController];

                
            }
        } else  if([segue.identifier isEqualToString:@"fromWorkoutToMap"]){
            if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {

                [self prepareMapViewController:segue.destinationViewController];
                
            }
        }
    }
}



@end
