//
//  SnakeLadder+CoreDataProperties.h
//  SnakeLadder
//
//  Created by Ranganatha G V on 16/01/2017.
//  Copyright © 2017 Cricbuzz. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "SnakeLadder+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SnakeLadder (CoreDataProperties)

+ (NSFetchRequest<SnakeLadder *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *playerName;
@property (nonatomic) int16_t curPosition;
@property (nonatomic) int16_t curDialNum;
@property (nonatomic) BOOL winner;

@end

NS_ASSUME_NONNULL_END
