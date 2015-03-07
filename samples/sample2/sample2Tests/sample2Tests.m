//
//  sample2Tests.m
//  sample2Tests
//
//  Created by Daniel BRAUN on 07/03/2015.
//  Copyright (c) 2015 Daniel BRAUN. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "GUITestSupport.h"
#import "DrawView.h"

@interface sample2Tests : XCTestCaseGUI

@end

@implementation sample2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1 {
    DrawView *dv = (DrawView *) [self findViewOfClass:@"DrawView" string:nil tag:-1];
    XCTAssert(dv);
    [self sleep:1];
    [self sendMouseClickToControl:dv];
    [self sleep:1];
    [self sendMouseClickToControl:dv];
    [self sleep:1];
    [self sendMouseClickToControl:dv onRight:YES];
    [self sendMouseClickToControl:dv onLeft:YES];
    [self sleep:2];
    XCTAssert(4==dv.numberOfPoints);
    XCTAssert(YES, @"Pass");
}

@end
