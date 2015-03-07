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

- (void) activateAndWaitAppActive;
- (void) waitAppActive;
- (NSString *) mainWindowTitle;
- (void) waitUntil:(BOOL(^)(void))cond;
- (void) sleep:(NSTimeInterval)duration;
- (NSWindow *) curWindow;
- (NSDictionary *) currentDescription;

- (NSView *)findViewOfClass:(NSString*)classname string:(NSString *)str_or_nil tag:(int)tag_or_minus1;
- (void) clickButton:(NSButton *)b;
- (void) setField:(NSTextField *)f string:(NSString *)s;

- (void) sendKeyboard:(NSString *)chars toControl:(NSControl *)ctrl;
- (void) sendMouseClickToControl:(NSView *)ctrl;
- (void) sendMouseClickToControl:(NSView *)ctrl onRight:(BOOL)onright;
- (void) sendMouseClickToControl:(NSView *)ctrl onLeft:(BOOL)onleft;

@end



@interface XCTestCaseGUIDoc : XCTestCaseGUI
- (id)curDoc;
- (NSDocument *) setupNewDoc;
- (void) closeAllDoc;

@end

@interface XCTestCaseGUINewDoc : XCTestCaseGUIDoc
@end

@interface NSView (Tests)

- (NSView *) findSuperViewOfClass:(Class)c;
- (NSView *) findSubviewOfClass:(Class)c havingText:(NSString *)text;
- (NSView *) findSubviewOfClass:(Class)c havingTextPrefix:(NSString *)text;

@end
