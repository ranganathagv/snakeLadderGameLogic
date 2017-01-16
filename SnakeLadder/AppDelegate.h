//
//  AppDelegate.h
//  SnakeLadder
//
//  Created by Ranganatha G V on 16/01/2017.
//  Copyright © 2017 Cricbuzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

