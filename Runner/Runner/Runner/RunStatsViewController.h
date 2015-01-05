//
//  runStatsViewController.h
//  Runner
//
//  Created by Administrator on 11/29/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run+Stats.h"
#import <AVFoundation/AVFoundation.h>

@interface RunStatsViewController : UITableViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Run *run;
@property (strong, nonatomic) NSMutableArray *intervals; // Of type Interval
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end
