//
//  SnakeLadder+CoreDataProperties.m
//  SnakeLadder
//
//  Created by Ranganatha G V on 16/01/2017.
//  Copyright © 2017 Cricbuzz. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SnakeLadder+CoreDataProperties.h"

@implementation SnakeLadder (CoreDataProperties)

+ (NSFetchRequest<SnakeLadder *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SnakeLadder"];
}

@dynamic playerName;
@dynamic curPosition;
@dynamic curDialNum;
@dynamic winner;

@end
