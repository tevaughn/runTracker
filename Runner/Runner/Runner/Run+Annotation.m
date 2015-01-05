//
//  Route+Annotation.m
//  tracker
//
//  Created by Administrator on 11/4/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Run+Annotation.h"
#import "Breadcrumb+Annotation.h"
#import <CoreLocation/CoreLocation.h>

@implementation Run (Annotation)

- (void)addBreadcrumbToEndOfRun:(Breadcrumb *)breadcrumb
{
    CLLocation *point1 = nil;
    CLLocation *point2 = nil;
    
    NSInteger time1 = 0;
    NSInteger time2 = 0;
    
    // Grab our most recent location
    if (self.breadcrumbs) {
    point1 = [[CLLocation alloc] initWithLatitude:[((Breadcrumb*)[self.breadcrumbs lastObject]).latitude doubleValue] longitude:[((Breadcrumb*)[self.breadcrumbs lastObject]).latitude doubleValue]];
        time1 = [((Breadcrumb*)[self.breadcrumbs lastObject]).time integerValue];
    }
    
    // Add a breadcrumb to the end of our route and increment count
    // Due to know apple bug, use this workaround:
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.breadcrumbs];
    [tempSet addObject:breadcrumb];
    self.breadcrumbs = tempSet;

    self.breadcrumbCount = [NSNumber numberWithInteger:[self.breadcrumbCount integerValue] + 1];

    // Grab our current location
    point2 = [[CLLocation alloc] initWithLatitude:[((Breadcrumb*)[self.breadcrumbs lastObject]).latitude doubleValue] longitude:[((Breadcrumb*)[self.breadcrumbs lastObject]).latitude doubleValue]];
    time2 = [((Breadcrumb*)[self.breadcrumbs lastObject]).time integerValue];
    
    float recentDistanceInM = [point1 distanceFromLocation:point2];
    float recentTime = time2 - time1;
    
    if ([self.breadcrumbCount integerValue] > 2) {
    // Update our distance
        self.distance = [NSNumber numberWithDouble:[self.distance doubleValue] + recentDistanceInM];
        self.currentPaceInSecondsPerKM = [[NSNumber alloc] initWithInteger: (recentTime / (recentDistanceInM / 1000 ))];
    }
}

@end
