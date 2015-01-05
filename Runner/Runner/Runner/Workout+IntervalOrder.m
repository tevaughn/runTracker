//
//  Workout+IntervalOrder.m
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Workout+IntervalOrder.h"
#import "Interval.h"

@implementation Workout (IntervalOrder)

- (void)deleteInterval:(Interval *)interval
{
    NSInteger order = [interval.order integerValue];
    [self removeIntervalsObject:interval];
    self.intervalCount = [[NSNumber alloc] initWithInteger:([self.intervalCount integerValue] - 1)];
    
    // If the interval was greater than the deleted interval, decrement
    for (interval in self.intervals) {
        if ([interval.order integerValue] > order) {
            interval.order = [[NSNumber alloc] initWithInteger:([interval.order integerValue] - 1)];
        }
    }
}

- (void)addIntervalToEndOfWorkout:(Interval *)interval
{
    [self addIntervalsObject:interval];
    interval.order = self.intervalCount;
    
    self.intervalCount = [[NSNumber alloc] initWithInteger:([self.intervalCount integerValue] + 1)];

}


- (void)selectWorkoutFromWorkouts:(NSArray *)workouts
{
    // If not already selected, select this workout
    if (![self.selected boolValue]){
        for (Workout *workout in workouts) {
            if (workout != self) {
                workout.selected = [[NSNumber alloc] initWithBool:false];
            }
        }
        self.selected = [[NSNumber alloc] initWithBool:true];
    }

    [self.managedObjectContext save:nil];
}

@end
