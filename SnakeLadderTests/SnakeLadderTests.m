//
//  SnakeLadderTests.m
//  SnakeLadderTests
//
//  Created by Ranganatha G V on 16/01/2017.
//  Copyright © 2017 Cricbuzz. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface SnakeLadderTests : XCTestCase

@end

@implementation SnakeLadderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *myVcObj = [sb instantiateViewControllerWithIdentifier:@"gameScreenSbId"];
    [myVcObj createGameboardPositions];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
