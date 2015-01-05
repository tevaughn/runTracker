//
//  Breadcrumb+Annotation.h
//  tracker
//
//  Created by Administrator on 11/4/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Breadcrumb.h"
#import <CoreLocation/CoreLocation.h>
#import "Run.h"

@interface Breadcrumb (Annotation)

- (CLLocationCoordinate2D)coordinate;
+ (void) addBreadcrumbAtLocation:(CLLocation *)location OnRun:(Run*)run inManagedObjectContext:(NSManagedObjectContext*)context;

@end
