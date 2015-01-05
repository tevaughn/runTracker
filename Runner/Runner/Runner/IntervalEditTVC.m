//
//  IntervalEditTVC.m
//  Runner
//
//  Created by Administrator on 11/27/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "IntervalEditTVC.h"
#import "Workout.h"
#import "Interval.h"
#import "IntervalCDTVC.h"
#import "Workout+IntervalOrder.h"

@interface IntervalEditTVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeTimeOrDistanceSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *lengthTextFieldMetersOrSeconds;
@property (weak, nonatomic) IBOutlet UITextField *lengthTextFieldKMetersOrMinutes;
@property (weak, nonatomic) IBOutlet UILabel *lengthColonOrPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthUnitsLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paceSegmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) NSString *pace;
@property (weak, nonatomic) NSString *type;
@property (nonatomic)       NSInteger length;

@end

@implementation IntervalEditTVC


- (void)setInterval:(Interval *)interval
{
    _interval = interval;
    self.pace = interval.pace;
    self.type = interval.typeDistanceOrTime;
    self.length = [interval.lengthInKmOrSeconds integerValue];
    
    [self setManagedObjectContext:interval.managedObjectContext];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( [[self.typeTimeOrDistanceSegmentedControl titleForSegmentAtIndex:0] isEqualToString:self.type] )
    {
        self.typeTimeOrDistanceSegmentedControl.selectedSegmentIndex = 0;
        self.lengthUnitsLabel.text = @" ";
        self.lengthColonOrPeriodLabel.text = @":";
        
        NSInteger minutes = self.length / 60 ;
        NSInteger seconds = self.length - (minutes * 60);
        
        self.lengthTextFieldKMetersOrMinutes.text = [NSString stringWithFormat:@"%01ld", (long)minutes];
        self.lengthTextFieldMetersOrSeconds.text = [NSString stringWithFormat:@"%02ld", (long)seconds];

    } else {
        self.typeTimeOrDistanceSegmentedControl.selectedSegmentIndex = 1;
        self.lengthUnitsLabel.text = @"Km";
        self.lengthColonOrPeriodLabel.text = @".";
        
        NSInteger kiloMeters = self.length / 1000 ;
        NSInteger meters = self.length - (kiloMeters * 1000);
        
        self.lengthTextFieldKMetersOrMinutes.text = [NSString stringWithFormat:@"%01ld", (long)kiloMeters];
        self.lengthTextFieldMetersOrSeconds.text = [NSString stringWithFormat:@"%03ld", (long)meters];
        
    }
    
    if ( [self.pace isEqualToString:@"Rest"]){
        self.paceSegmentedControl.selectedSegmentIndex = 0;
    } else if ( [self.pace isEqualToString:@"Slow"]){
        self.paceSegmentedControl.selectedSegmentIndex = 1;
    } else if ( [self.pace isEqualToString:@"Steady"]){
        self.paceSegmentedControl.selectedSegmentIndex = 2;
    } else if ( [self.pace isEqualToString:@"Fast"]){
        self.paceSegmentedControl.selectedSegmentIndex = 3;
    }
}

- (IBAction)didUpdateLength:(id)sender {
    
    // Get Km and conver to m
    if ([self.type isEqualToString:@"Time"]) {
        self.length = [self.lengthTextFieldKMetersOrMinutes.text integerValue] * 60 + [self.lengthTextFieldMetersOrSeconds.text integerValue];
      
    } else {
        self.length = [self.lengthTextFieldKMetersOrMinutes.text floatValue] * 1000 + [self.lengthTextFieldMetersOrSeconds.text integerValue];
    }
    
}


- (IBAction)didToggleTimeDistanceSeg:(id)sender {
    
    if (self.typeTimeOrDistanceSegmentedControl.selectedSegmentIndex == 0) {
        self.type = @"Time";
        self.lengthUnitsLabel.text = @"  ";
        self.lengthColonOrPeriodLabel.text = @":";
        self.lengthTextFieldKMetersOrMinutes.text = @"0";
        self.lengthTextFieldMetersOrSeconds.text = @"00";
    } else {
        self.type = @"Distance";
        self.lengthUnitsLabel.text = @"Km";
        self.lengthColonOrPeriodLabel.text = @".";
        self.lengthTextFieldKMetersOrMinutes.text = @"0";
        self.lengthTextFieldMetersOrSeconds.text = @"000";
    }
}

- (IBAction)didPressDeleteButton:(id)sender {
    [self.managedObjectContext performBlockAndWait:^(void){
        // Delete the interval and go back
        [self.interval.workout deleteInterval:self.interval];
        
        self.interval = nil;
        [self.managedObjectContext save:nil];

        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)didTogglePaceSeg:(id)sender {
    
    switch (self.paceSegmentedControl.selectedSegmentIndex) {
        case 0: self.pace = @"Rest";
            break;
        case 1: self.pace = @"Slow";
            break;
        case 2: self.pace = @"Steady";
            break;
        case 3: self.pace = @"Fast";
            break;
    }
}

- (IBAction)didPressSaveButton:(id)sender {
    // Copy local values to core data and save then pop
    [self.managedObjectContext performBlockAndWait:^(void){
        self.interval.pace = self.pace;
        self.interval.typeDistanceOrTime = self.type;
        
        if ([self.type isEqualToString:@"Time"]) {
            self.length = [self.lengthTextFieldKMetersOrMinutes.text integerValue] * 60 + [self.lengthTextFieldMetersOrSeconds.text integerValue];
            
        } else {
            self.length = [self.lengthTextFieldKMetersOrMinutes.text floatValue] * 1000 + [self.lengthTextFieldMetersOrSeconds.text integerValue];
        }
        
        self.interval.lengthInKmOrSeconds = [[NSNumber alloc] initWithInteger:self.length];
        //[self.managedObjectContext save:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
