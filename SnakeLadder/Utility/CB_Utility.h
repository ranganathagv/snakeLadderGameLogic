//
//  CB_Utility.h
//  SnakeLadder
//
//  Created by Ranganatha G V on 17/01/2017.
//  Copyright © 2017 Cricbuzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CB_Utility : NSObject
+ (instancetype)sharedInstance;
+ (NSManagedObjectContext *)managedObjectContext;
@end
