//
//  Example1Tests.m
//  Example1Tests
//
//  Created by Daniel BRAUN on 07/03/2015.
//  Copyright (c) 2015 Daniel BRAUN. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "GUITestSupport.h"

@interface Example1Tests : XCTestCaseGUI

@end

@implementation Example1Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test1 {
    /* 
     * basic test : input two numbers to field "a" and "b", and check the result
     */
    NSTextField *f1 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:1];
    NSTextField *f2 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:2];
    NSTextField *f3 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:3];
    XCTAssert(f1);
    XCTAssert(f2);
    XCTAssert(f3);
    [self sendMouseClickToControl:f1];[self sleep:0.1];
    [self sendKeyboard:@"\n2\n" toControl:f1];
    [self sleep:0.1];
    [self sendMouseClickToControl:f2];[self sleep:0.1];
    [self sendKeyboard:@"\n3\n" toControl:f2];
    [self sleep:0.1];

    NSString *s = [f3 stringValue];
    XCTAssert([s isEqualToString:@"5"]);
}

- (void)testNextKeyView {
    /*
     * in the application, we carrefully set the nextKeyView so that focus goes through the fields by
     * pressing tab key.
     * we check this in this test, by sending tab keystroke
     */
    NSTextField *f1 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:1];
    NSTextField *f2 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:2];
    NSTextField *f3 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:3];
    XCTAssert(f1);
    XCTAssert(f2);
    XCTAssert(f3);
    [self sleep:0.5];
    [self sendMouseClickToControl:f1 onLeft:YES];
    [self sleep:0.1];
    [self sendKeyboard:@"\n23\t32\t" toControl:f1];
    [self sleep:0.1];
    
    NSString *s = [f3 stringValue];
    XCTAssert([s isEqualToString:@"55"]);

    XCTAssert(YES, @"Pass");
}


- (void)test2 {
    /*
     * another test, showing that when sending text to a NSTextField, we can either append
     * the content (default) or replace it (by sending a \n before)
     */
    NSTextField *f1 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:1];
    NSTextField *f2 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:2];
    NSTextField *f3 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:3];
    XCTAssert(f1);
    XCTAssert(f2);
    XCTAssert(f3);
    [self sleep:0.1];
    [self sendMouseClickToControl:f1];
    [self sleep:0.1];
    [self sendKeyboard:@"\n2\t3\n" toControl:f1];
    [self sleep:0.1];
    NSString *s = [f3 stringValue];
    XCTAssert([s isEqualToString:@"5"]);
    
    [self sleep:1];
    [self sendMouseClickToControl:f1 onRight:NO];[self sleep:0.1];
    //[self sendMouseClickToControl:f1 onRight:NO];[self sleep:5];
    [self sendKeyboard:@"44\n" toControl:f2];
    [self sleep:0.1];
     
     s = [f3 stringValue];
     XCTAssert([s isEqualToString:@"247"]);


}

#if 0
// playground
- (void) testEvt
{
   
    NSTextField *f1 = (NSTextField *)[self findViewOfClass:@"NSTextField" string:nil tag:1];
    XCTAssert(f1);
    [self sendMouseClickToControl:f1]; [self sleep:0.4];
    NSTextField *fd = (NSTextField *)[self findViewOfClass:@"LogTextField" string:nil tag:-1];
    XCTAssert(fd);
    [self sleep:0.1];
    NSLog(@"......\n");
    [self sendMouseClickToControl:fd];
    [self sleep:1];
    NSLog(@"------\n");
    [self sleep:30];
}
#endif
@end
