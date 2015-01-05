//
//  Breadcrumb+Annotation.m
//  tracker
//
//  Created by Administrator on 11/4/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Breadcrumb+Annotation.h"
#import "Run+Annotation.h"

@implementation Breadcrumb (Annotation)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    
    return coordinate;
}

+ (void) addBreadcrumbAtLocation:(CLLocation*)location OnRun:(Run *)run inManagedObjectContext:(NSManagedObjectContext *)context
{
    Breadcrumb *breadcrumb = [NSEntityDescription insertNewObjectForEntityForName:@"Breadcrumb" inManagedObjectContext:context];
    breadcrumb.latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
    breadcrumb.longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
    breadcrumb.time = [[NSNumber alloc] initWithInteger:[location.timestamp timeIntervalSince1970]];
    
    [run addBreadcrumbToEndOfRun:breadcrumb];
    //[context save:nil];
    

}


@end
