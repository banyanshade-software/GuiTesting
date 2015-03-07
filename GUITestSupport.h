//
//  DbnTestSupport.h
//  SmartBank
//
//  Created by Daniel BRAUN on 14/10/2014.
//  Copyright (c) 2014 Daniel BRAUN. All rights reserved.
//

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
