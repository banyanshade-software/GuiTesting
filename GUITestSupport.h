//
//  DbnTestSupport.h
//  SmartBank
//
//  Created by Daniel BRAUN on 14/10/2014.
//  Copyright (c) 2014 Daniel BRAUN. All rights reserved.
//
/*
 Copyright 2014-2015 Daniel Braun
 All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface NSView (Testing)

- (NSDictionary *) testDescription;

@end

@interface NSWindow (Testing)

- (NSDictionary *) testDescription;

@end



@interface XCTestCaseGUI : XCTestCase

/* override mainWindowTitle if you have several windows. Each test case
 * shall then focuse on a given window
 */
- (NSString *) mainWindowTitle;

/*
 * view finding : findViewOfClass:string:tag: is the main method to find view in view hierarchy
 * for debug purpose, you can call currentDescription:
 */
- (NSView *)findViewOfClass:(NSString*)classname string:(NSString *)str_or_nil tag:(int)tag_or_minus1;
- (NSDictionary *) currentDescription;

- (NSWindow *) curWindow;

/*
 * consume NSEvent and wait for conditions
 */
- (void) waitUntil:(BOOL(^)(void))cond;
- (void) sleep:(NSTimeInterval)duration;

/* 
 * application activation. You normally don't have to call these methods, it's done in setUp
 */
- (void) activateAndWaitAppActive;
- (void) waitAppActive;

/*
 * send keyboard and mouse events to the GUI
 * this is preliminary, and handles modifier and other mouse buttons
 * as well as mouse position
 */
- (void) setField:(NSTextField *)f string:(NSString *)s;

- (void) sendKeyboard:(NSString *)chars toControl:(NSControl *)ctrl;
- (void) sendMouseClickToControl:(NSView *)ctrl;
- (void) sendMouseClickToControl:(NSView *)ctrl onRight:(BOOL)onright;
- (void) sendMouseClickToControl:(NSView *)ctrl onLeft:(BOOL)onleft;

/*
 * more high level interraction, directly invoking the methods of the control
 */
- (void) clickButton:(NSButton *)b;


@end



@interface XCTestCaseGUIDoc : XCTestCaseGUI
- (id)curDoc;
- (NSDocument *) setupNewDoc;
- (void) closeAllDoc;

@end

// init with a new empty doc
@interface XCTestCaseGUINewDoc : XCTestCaseGUIDoc
@end

// init by sending specific msg to delegate
@interface XCTestCaseGUIdelegate : XCTestCaseGUIDoc
@end

@interface NSView (Tests)

- (NSView *) findSuperViewOfClass:(Class)c;
- (NSView *) findSubviewOfClass:(Class)c havingText:(NSString *)text;
- (NSView *) findSubviewOfClass:(Class)c havingTextPrefix:(NSString *)text;
- (NSArray<NSView *>*) findAllSubviewsOfClass:(Class)c havingText:(NSString *)text;
@end
