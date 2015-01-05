//
//  AppDelegate.m
//  Runner
//
//  Created by Administrator on 10/28/14.
//  Copyright (c) 2014 Rice University. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "Breadcrumb+Annotation.h"
#import "Workout.h"
#import "Interval+Order.h"
#import "ViewController.h"
@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic) BOOL finishedSaving;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    [self startAudioSession];
    [self startFileManager];
    
    return YES;
}

- (void)startAudioSession
{
    NSError *error;
    
    // Set up audio session
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                     withOptions:(kAudioSessionProperty_OverrideCategoryMixWithOthers |kAudioSessionProperty_OtherMixableAudioShouldDuck)
                                           error:&error];
    
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:self.managedObjectContext];
}

- (void)contextChanges:(NSNotification *)notification
{
    //[self.trackerDocument savePresentedItemChangesWithCompletionHandler:nil];
    if (self.finishedSaving){
        self.finishedSaving = false;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //[self.trackerDocument saveToURL:self.trackerDocumentURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            [self.trackerDocument savePresentedItemChangesWithCompletionHandler:^(NSError *errorOrNil) {
                self.finishedSaving = true;
                if (errorOrNil){
                    NSLog(@"error:%@",errorOrNil);
                }
            }];
            
            
        });
    }
    
}

- (void)startFileManager
{
    // Set up file manager
    NSFileManager *fileManager = [NSFileManager defaultManager]; // Get the file manager
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject]; // Get directory URL
    NSString *documentName = @"RunLogDoc"; // Set document name
    self.trackerDocumentURL = [documentsDirectory URLByAppendingPathComponent:documentName]; // Create document URL
    self.trackerDocument = [[UIManagedDocument alloc] initWithFileURL:self.trackerDocumentURL]; // init document at url
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self.trackerDocumentURL path]];
    if (fileExists) {
        [self.trackerDocument openWithCompletionHandler:^(BOOL success) {
            if (success)
            {
                
                self.managedObjectContext = self.trackerDocument.managedObjectContext;
                [((ViewController*)((UITabBarController*)((UINavigationController *)self.window.rootViewController).visibleViewController).selectedViewController) setManagedObjectContext:self.managedObjectContext];
                self.finishedSaving = true;
            }
            if (!success){
                NSLog(@"could not open document ");
            }
        }];
        
    } else {
        // create the document
        [self.trackerDocument saveToURL:self.trackerDocumentURL
                       forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:^(BOOL success) {
                          
                          self.managedObjectContext = self.trackerDocument.managedObjectContext;
                          
                          [((ViewController*)((UITabBarController*)((UINavigationController *)self.window.rootViewController).visibleViewController).selectedViewController) setManagedObjectContext:self.managedObjectContext];
                          self.finishedSaving = true;
                          
                      }];
    }
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

