//
//  Interval.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Workout;

@interface Interval : NSManagedObject

@property (nonatomic, retain) NSNumber * lengthInKmOrSeconds;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * pace;
@property (nonatomic, retain) NSString * typeDistanceOrTime;
@property (nonatomic, retain) Workout *workout;

@end
