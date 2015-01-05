//
//  IntervalEditTVC.h
//  Runner
//
//  Created by Administrator on 11/27/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interval.h"

@interface IntervalEditTVC : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Interval *interval;

@end
