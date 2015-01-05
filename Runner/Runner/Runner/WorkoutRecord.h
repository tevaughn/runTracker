//
//  WorkoutRecord.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Run;

@interface WorkoutRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * distanceInKm;
@property (nonatomic, retain) NSNumber * timeInS;
@property (nonatomic, retain) Run *run;

@end
