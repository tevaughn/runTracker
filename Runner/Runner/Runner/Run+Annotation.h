//
//  Route+Annotation.h
//  tracker
//
//  Created by Administrator on 11/4/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "Run.h"

@interface Run (Annotation)

- (void)addBreadcrumbToEndOfRun:(Breadcrumb *)breadcrumb;

@end
