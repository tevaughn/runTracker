//
//  Run+Stats.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Run.h"
#import <CoreLocation/CoreLocation.h>

@interface Run (Stats)

- (void) initalizeRunForWorkout:(Workout *)workout forStartTime:(NSInteger)startTime atCoordinates:(CLLocationCoordinate2D)coordinates inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)currentIntervalCompleted;
- (void)insertFinalIntervalAtCount:(NSInteger)count;
- (void)workoutCompleted;

- (NSInteger)getCurrentRunTimeInSeconds;
- (NSInteger)getCurrentRunDistaceInMeters;
- (NSInteger)getCurrentPaceInSecondsPerKM;

- (NSInteger)getIntervalDistanceForIntervalCount:(NSInteger)count;
- (NSInteger)getIntervalTimeForIntervalCount:(NSInteger)count;
- (NSInteger)getIntervalAvgPaceInSecondsPerKMForIntervalCount:(NSInteger)count;

@end
