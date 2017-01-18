//
//  CB_Utility.m
//  SnakeLadder
//
//  Created by Ranganatha G V on 17/01/2017.
//  Copyright © 2017 Cricbuzz. All rights reserved.
//

#import "CB_Utility.h"
#import "AppDelegate.h"

@implementation CB_Utility

+ (instancetype)sharedInstance {
    static CB_Utility *sharedObj = nil;
    static dispatch_once_t dispatchToken;
    _dispatch_once(&dispatchToken, ^{
        sharedObj = [[CB_Utility alloc] init];
    });
    return sharedObj;
}

+ (NSManagedObjectContext *)managedObjectContext {
    static NSManagedObjectContext *managedObjectContext = nil;
    if (!managedObjectContext)
    {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.persistentContainer.viewContext;
    }
    return managedObjectContext;
}

@end
