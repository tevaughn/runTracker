//
//  AppDelegate.h
//  Runner
//
//  Created by Administrator on 10/28/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIManagedDocument *trackerDocument;
@property (strong, nonatomic) NSURL *trackerDocumentURL;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

