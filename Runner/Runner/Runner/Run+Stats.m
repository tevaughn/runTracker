//
//  Run+Stats.m
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Run+Stats.h"
#import "Run+Annotation.h"
#import "WorkoutRecord.h"
#import "Workout+IntervalOrder.h"
#import "Interval.h"
#import "IntervalRecord.h"
#import "Breadcrumb.h"

@implementation Run (Stats)

- (void) initalizeRunForWorkout:(Workout *)workout forStartTime:(NSInteger)startTime atCoordinates:(CLLocationCoordinate2D)coordinates inManagedObjectContext:(NSManagedObjectContext *)context
{
    self.workout = workout;
    
    WorkoutRecord *workoutRecord = [NSEntityDescription insertNewObjectForEntityForName:@"WorkoutRecord" inManagedObjectContext:context];
    workoutRecord.run = self;
    
    self.currentInterval = 0;
    for (Interval *interval in workout.intervals) {
        IntervalRecord *intervalRecord = [NSEntityDescription insertNewObjectForEntityForName:@"IntervalRecord" inManagedObjectContext:context];
        intervalRecord.order = interval.order;
        intervalRecord.run = self;
    }
    
    Breadcrumb *breadcrumb = [NSEntityDescription insertNewObjectForEntityForName:@"Breadcrumb" inManagedObjectContext:context];
    breadcrumb.run = self;
    breadcrumb.latitude = [[NSNumber alloc] initWithFloat:coordinates.latitude];
    breadcrumb.longitude = [[NSNumber alloc] initWithFloat:coordinates.longitude];
    breadcrumb.time = [[NSNumber alloc] initWithInteger:startTime];
    
    self.startTime = [[NSNumber alloc] initWithInteger:startTime];
    self.breadcrumbCount = 0;
    self.completed = [[NSNumber alloc] initWithBool: false];
    
}

- (void)insertFinalIntervalAtCount:(NSInteger)count
{
    IntervalRecord *intervalRecord = [NSEntityDescription insertNewObjectForEntityForName:@"IntervalRecord" inManagedObjectContext:self.managedObjectContext];
    intervalRecord.order = [[NSNumber alloc] initWithInteger: count];
    intervalRecord.run = self;
}

- (void)currentIntervalCompleted
{
    // Find the interval and set it's time and distance
    for(IntervalRecord *intervalRecord in self.intervalRecords)
    {
        if ([intervalRecord.order integerValue] == [self.currentInterval integerValue]) {
            intervalRecord.distanceInKm = [[NSNumber alloc] initWithInteger:[self getIntervalDistanceForIntervalCount:[self.currentInterval integerValue]]];
            intervalRecord.timeInS = [[NSNumber alloc] initWithInteger:[self getIntervalTimeForIntervalCount:[self.currentInterval integerValue]]];
            
        }
    }
    self.currentInterval = [[NSNumber alloc] initWithInteger:([self.currentInterval integerValue] + 1 )];
}


- (void)workoutCompleted
{
    [self currentIntervalCompleted];
    self.workoutRecord.distanceInKm = [[NSNumber alloc] initWithInteger:[self getCurrentRunDistaceInMeters]];
    self.workoutRecord.timeInS = [[NSNumber alloc] initWithInteger:[self getCurrentRunTimeInSeconds]];
    self.completed = [[NSNumber alloc] initWithBool:true];
}


- (NSInteger)getCurrentRunTimeInSeconds
{
    NSInteger currentTime = CFAbsoluteTimeGetCurrent();
    NSInteger startTime = [self.startTime integerValue];
    return (currentTime - startTime );

}

- (NSInteger)getCurrentRunDistaceInMeters
{
    return [self.distance integerValue];
}

- (NSInteger)getCurrentPaceInSecondsPerKM
{
    float distanceInM = [self getCurrentRunDistaceInMeters];
    float time = [self getCurrentRunTimeInSeconds];
    
    return ( distanceInM ? ( time / distanceInM ) *1000 : 0);
}

- (NSInteger)getIntervalDistanceForIntervalCount:(NSInteger)count
{
    
    NSInteger distance = 0;
    if (count < [self.currentInterval integerValue])
    {
        for (IntervalRecord *intervalRecord in self.intervalRecords) {
            if ([intervalRecord.order integerValue] == count) {
                distance = [intervalRecord.distanceInKm integerValue];
            }
        }
    } else if (count == [self.currentInterval integerValue] ) {
        for (IntervalRecord *intervalRecord in self.intervalRecords) {
            if ([intervalRecord.order integerValue] < count) {
                distance = [intervalRecord.distanceInKm integerValue] + distance;
            }
        }
        distance = [self getCurrentRunDistaceInMeters] - distance;
    }
    
    return distance;
}

- (NSInteger)getIntervalTimeForIntervalCount:(NSInteger)count
{
    
    NSInteger time = 0;
    if (count < [self.currentInterval integerValue])
    {
        for (IntervalRecord *intervalRecord in self.intervalRecords) {
            if ([intervalRecord.order integerValue] == count) {
                time = [intervalRecord.timeInS integerValue];
            }
        }
    } else if (count == [self.currentInterval integerValue] ) {
        for (IntervalRecord *intervalRecord in self.intervalRecords) {
            if ([intervalRecord.order integerValue] < count) {
                time = [intervalRecord.timeInS integerValue] + time;
            }
        }
        time = [self getCurrentRunTimeInSeconds] - time;
    }
    
    return time;
}

- (NSInteger)getIntervalAvgPaceInSecondsPerKMForIntervalCount:(NSInteger)count
{
    float distanceInM = [self getIntervalDistanceForIntervalCount:count];
    float time = [self getIntervalTimeForIntervalCount:count];
    
    return ( distanceInM ? ( time / distanceInM ) * 1000 : 0);
}

@end
