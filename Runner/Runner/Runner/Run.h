//
//  Run.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Breadcrumb, IntervalRecord, Workout, WorkoutRecord;

@interface Run : NSManagedObject

@property (nonatomic, retain) NSNumber * breadcrumbCount;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSNumber * currentInterval;
@property (nonatomic, retain) NSNumber * currentPaceInSecondsPerKM;
@property (nonatomic, retain) NSOrderedSet *breadcrumbs;
@property (nonatomic, retain) Workout *workout;
@property (nonatomic, retain) WorkoutRecord *workoutRecord;
@property (nonatomic, retain) NSSet *intervalRecords;
@end

@interface Run (CoreDataGeneratedAccessors)

- (void)insertObject:(Breadcrumb *)value inBreadcrumbsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBreadcrumbsAtIndex:(NSUInteger)idx;
- (void)insertBreadcrumbs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBreadcrumbsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBreadcrumbsAtIndex:(NSUInteger)idx withObject:(Breadcrumb *)value;
- (void)replaceBreadcrumbsAtIndexes:(NSIndexSet *)indexes withBreadcrumbs:(NSArray *)values;
- (void)addBreadcrumbsObject:(Breadcrumb *)value;
- (void)removeBreadcrumbsObject:(Breadcrumb *)value;
- (void)addBreadcrumbs:(NSOrderedSet *)values;
- (void)removeBreadcrumbs:(NSOrderedSet *)values;
- (void)addIntervalRecordsObject:(IntervalRecord *)value;
- (void)removeIntervalRecordsObject:(IntervalRecord *)value;
- (void)addIntervalRecords:(NSSet *)values;
- (void)removeIntervalRecords:(NSSet *)values;

@end
