//
//  Workout+IntervalOrder.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Workout.h"

@interface Workout (IntervalOrder)

- (void)deleteInterval:(Interval *)interval;
- (void)addIntervalToEndOfWorkout:(Interval *)interval;

- (void)selectWorkoutFromWorkouts:(NSArray *)workouts;

@end
