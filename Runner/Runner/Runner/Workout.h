//
//  Workout.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Interval, Run;

@interface Workout : NSManagedObject

@property (nonatomic, retain) NSNumber * intervalCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSSet *runs;
@property (nonatomic, retain) NSSet *intervals;
@end

@interface Workout (CoreDataGeneratedAccessors)

- (void)addRunsObject:(Run *)value;
- (void)removeRunsObject:(Run *)value;
- (void)addRuns:(NSSet *)values;
- (void)removeRuns:(NSSet *)values;

- (void)addIntervalsObject:(Interval *)value;
- (void)removeIntervalsObject:(Interval *)value;
- (void)addIntervals:(NSSet *)values;
- (void)removeIntervals:(NSSet *)values;

@end
